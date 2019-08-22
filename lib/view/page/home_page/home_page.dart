import 'package:flutter/material.dart';
import 'package:flutter_shell/localization/app_translation.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/tools/internet_provider.dart';
import 'package:flutter_shell/view/page/commingsoon_page/commingsoon_bloc.dart';
import 'package:flutter_shell/view/page/commingsoon_page/commingsoon_screen.dart';
import 'package:flutter_shell/view/page/nowplaying_page/nowplaing_screen.dart';
import 'package:flutter_shell/view/page/nowplaying_page/nowplaying_bloc.dart';
import 'package:flutter_shell/view/page/popular_page/popular_bloc.dart';
import 'package:flutter_shell/view/page/popular_page/popular_screen.dart';
import 'package:flutter_shell/view/page/search_page/search_screen.dart';
import 'package:flutter_shell/view/page/setting_page/setting_page.dart';
import 'package:flutter_shell/view/page/toprated_page/toprated_bloc.dart';
import 'package:flutter_shell/view/page/toprated_page/toprated_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController refreshController;
  NowPlayingBloc nowPlayingBloc;
  TopRatedBloc topRatedBloc;
  PopularBloc popularBloc;
  CommingSoonBloc commingSoonBloc;
  bool flag = true;

  bool searchflag = true;
  double _searchX = 5.0;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    nowPlayingBloc = NowPlayingBloc();
    topRatedBloc = TopRatedBloc();
    popularBloc = PopularBloc();
    commingSoonBloc = CommingSoonBloc();
    nowPlayingBloc.nowPlayingStream().listen((rv) {
      refreshController.refreshCompleted();
      refreshController.resetNoData();
      if (rv.message == MsgState.data) {
        setState(() {
          flag = true;
          print(flag);
        });
      } else {
        setState(() {
          flag = false;
          print(flag);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isInternet = InternetProvider.of(context).internet;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          AppTranslations.of(context).trans('moviedb'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SearchScreen()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return SettingPage();
              }));
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: () {
          SharedPref.setData(key: SharedPref.nowPlaying, value: null);
          SharedPref.setData(key: SharedPref.topRated, value: null);
          SharedPref.setData(key: SharedPref.popular, value: null);
          SharedPref.setData(key: SharedPref.commingsoon, value: null);
          nowPlayingBloc.getNowPlayingMovie();
          // topRatedBloc.getTopRatedMovie();
          // popularBloc.getPopularMovie();
          // commingSoonBloc.getCommingSoonMovie();
        },
        child: flag
            ? ListView(
                children: <Widget>[
                  isInternet
                      ? Container()
                      : Container(
                          color: Colors.red,
                          child: Center(
                              child: Text(AppTranslations.of(context)
                                  .trans("no_internet"))),
                        ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      AppTranslations.of(context).trans("nowplaying"),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 33),
                    ),
                  ),
                  NowPlaying(),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      AppTranslations.of(context).trans("toprated"),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 33),
                    ),
                  ),
                  TopRatedScreen(),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      AppTranslations.of(context).trans("popular"),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 33),
                    ),
                  ),
                  PopularScreen(),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      AppTranslations.of(context).trans("commingsoon"),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 33),
                    ),
                  ),
                  CommingSoonScreen(),
                ],
              )
            : Center(
                child: Container(
                    width: 100,
                    height: 100,
                    child: Image.asset("images/loading2.gif")),
              ),
      ),
    );
  }
}
