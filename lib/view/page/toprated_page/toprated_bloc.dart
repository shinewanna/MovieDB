import 'dart:convert';

import 'package:flutter_shell/network/base_network.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class TopRatedBloc extends BaseNetwork {
  PublishSubject<ResponseOb> topRatedController = PublishSubject<ResponseOb>();
  Observable<ResponseOb> topRatedStream() {
    return topRatedController.stream;
  }

  PublishSubject<ResponseOb> moreTopRatedController =
      PublishSubject<ResponseOb>();
  Observable<ResponseOb> moreTopRatedStream() {
    return moreTopRatedController.stream;
  }

  static int page = 1;

  getTopRatedMovie() {
    page = 1;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    topRatedController.sink.add(rv);

    SharedPref.getData(key: SharedPref.topRated).then((r) {
      if (r != null) {
        MovieOb ob = MovieOb.fromJson(json.decode(r));
        rv.message = MsgState.data;
        rv.data = ob.results;
        topRatedController.sink.add(rv);
      }
    });

    getRequest(endUrl: TOP_RATED_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        SharedPref.setData(
            key: SharedPref.topRated, value: resp.data.toString());
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        topRatedController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        topRatedController.sink.add(rv);
      }
    });
  }

  getMoreTopRatedMovie() {
    page++;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    moreTopRatedController.sink.add(rv);

    getRequest(endUrl: TOP_RATED_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        moreTopRatedController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        moreTopRatedController.sink.add(rv);
      }
    });
  }

  void dispose() {
    topRatedController.close();
    moreTopRatedController.close();
  }
}
