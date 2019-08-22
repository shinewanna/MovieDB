import 'dart:convert';

import 'package:flutter_shell/network/base_network.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingBloc extends BaseNetwork {
  PublishSubject<ResponseOb> nowPlayingController =
      PublishSubject<ResponseOb>();
  Observable<ResponseOb> nowPlayingStream() {
    return nowPlayingController.stream;
  }

  PublishSubject<ResponseOb> moreNowPlayingController =
      PublishSubject<ResponseOb>();
  Observable<ResponseOb> moreNowPlayingStream() {
    return moreNowPlayingController.stream;
  }

  static int page = 1;

  getNowPlayingMovie() {
    page = 1;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    nowPlayingController.sink.add(rv);

    SharedPref.getData(key: SharedPref.nowPlaying).then((r) {
      if (r != null) {
        print(r);
        MovieOb ob = MovieOb.fromJson(json.decode(r));
        rv.message = MsgState.data;
        rv.data = ob.results;
        nowPlayingController.sink.add(rv);
      }
    });

    getRequest(endUrl: NOW_PLAYING_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        SharedPref.setData(
            key: SharedPref.nowPlaying, value: resp.data.toString());
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        nowPlayingController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        nowPlayingController.sink.add(rv);
      }
    });
  }

  getMoreNowPlayingMovie() {
    page++;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    moreNowPlayingController.sink.add(rv);

    getRequest(endUrl: NOW_PLAYING_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        moreNowPlayingController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        moreNowPlayingController.sink.add(rv);
      }
    });
  }

  void dispose() {
    nowPlayingController.close();
    moreNowPlayingController.close();
  }
}
