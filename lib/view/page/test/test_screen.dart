import 'package:flutter/material.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:flutter_shell/view/page/commingsoon_page/commingsoon_bloc.dart';
import 'package:flutter_shell/view/page/popular_page/popular_bloc.dart';
import 'package:flutter_shell/view/page/test/test_bloc.dart';
import 'package:flutter_shell/view/page/widget/view_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommingSoonScreen extends StatefulWidget {
  @override
  _CommingSoonScreenState createState() => _CommingSoonScreenState();
}

class _CommingSoonScreenState extends State<CommingSoonScreen> {
  RefreshController refreshController;
  List<Results> results = [];
  SearchBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = SearchBloc();
    bloc.getSearchMovie("lion king");
    refreshController = RefreshController();
    bloc.searchStream().listen((rv) {
      refreshController.refreshCompleted();
      refreshController.resetNoData();
      if (rv.message == MsgState.data) {
        setState(() {
          results = rv.data;
        });
      }
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
        stream: bloc.searchStream(),
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
                bloc.getSearchMovie("lion king");
              },
              child: ListView.builder(
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
