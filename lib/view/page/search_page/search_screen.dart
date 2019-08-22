import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/view/page/description_page/description_screen.dart';
import 'package:flutter_shell/view/page/search_page/search_bloc.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller;
  RefreshController refreshController;
  List<Results> results = [];

  static Set<Results> recentSearch = HashSet<Results>();

  double searchH;
  String searchValue;
  SearchBloc bloc;

  search(double w, double h) {
    setState(() {
      searchH = searchH == 0 ? h - (h / 6.5) : 0;
    });
  }

  @override
  void initState() {
    super.initState();
    searchH = 0.0;
    searchValue = "";
    controller = TextEditingController();
    refreshController = RefreshController();
    bloc = SearchBloc();
    bloc.searchStream().listen((rv) {
      refreshController.refreshCompleted();
      refreshController.resetNoData();
      if (rv.message == MsgState.data) {
        setState(() {
          results = rv.data;
        });
      }
    });

    bloc.moreSearchStream().listen((rv) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: TextField(
          style: TextStyle(color: Colors.white),
          onChanged: (val) {
            setState(() {
              searchValue = val;
              bloc.getSearchMovie(searchValue);
            });
          },
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColor,
          ),
          Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent Searches",
                    style: TextStyle(color: Colors.white),
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    searchValue,
                    style: TextStyle(color: Colors.white),
                  )),
              Flexible(
                child: ListView.builder(
                  itemCount: recentSearch.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DescriptionScreen(
                                      result: recentSearch.elementAt(
                                          (recentSearch.length - 1) - index),
                                    )));
                      },
                      child: ListTile(
                        title: Text(
                          recentSearch
                              .elementAt((recentSearch.length - 1) - index)
                              .title,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: double.infinity,
              height: searchValue.length == 0 ? 0.0 : h - (h / 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: StreamBuilder(
                  initialData:
                      ResponseOb(data: null, message: MsgState.loading),
                  stream: bloc.searchStream(),
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
                          bloc.getMoreSearchMovie(searchValue);
                        },
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  recentSearch.add(results[index]);

                                  return DescriptionScreen(
                                      result: results[index]);
                                }));
                              },
                              child: ListTile(
                                title: Text(
                                  results[index].title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
