import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:flutter_shell/view/page/popular_page/popular_bloc.dart';
import 'package:flutter_shell/view/page/toprated_page/toprated_bloc.dart';
import 'package:flutter_shell/view/page/widget/view_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopRatedScreen extends StatefulWidget {
  @override
  _TopRatedScreenState createState() => _TopRatedScreenState();
}

class _TopRatedScreenState extends State<TopRatedScreen> {
  RefreshController refreshController;
  List<Results> results = [];
  TopRatedBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TopRatedBloc();
    bloc.getTopRatedMovie();
    refreshController = RefreshController();
    bloc.topRatedStream().listen((rv) {
      refreshController.refreshCompleted();
      refreshController.resetNoData();
      if (rv.message == MsgState.data) {
        setState(() {
          results = rv.data;
        });
      }
    });

    bloc.moreTopRatedStream().listen((rv) {
      if (rv.message == MsgState.data) {
        refreshController.loadComplete();
        try {
          setState(() {
            results.addAll(rv.data);
          });
        } catch (e) {
          print(e.toString());
        }
      }

      if (rv.message == MsgState.error) {
        if (rv.data == "no more") {
          refreshController.loadNoData();
        }
      }
      print(results.length);
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      child: StreamBuilder(
        stream: bloc.topRatedStream(),
        initialData: ResponseOb(data: null, message: MsgState.loading),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          ResponseOb ob = snapshot.data;

          if (ob.message == MsgState.loading) {
            return Center(
              child: Container(
                  width: 100,
                  height: 100,
                  child: Image.asset("images/loading2.gif")),
            );
          } else {
            return SmartRefresher(
              controller: refreshController,
              enablePullUp: true,
              enablePullDown: false,
              onLoading: () {
                bloc.getMoreTopRatedMovie();
              },
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  return viewWidget(context, results[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
