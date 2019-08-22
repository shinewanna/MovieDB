import 'dart:convert';

import 'package:flutter_shell/network/base_network.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class PopularBloc extends BaseNetwork {
  PublishSubject<ResponseOb> popularController = PublishSubject<ResponseOb>();
  Observable<ResponseOb> popularStream() {
    return popularController.stream;
  }

  PublishSubject<ResponseOb> morePopularController =
      PublishSubject<ResponseOb>();
  Observable<ResponseOb> morePopularStream() {
    return morePopularController.stream;
  }

  static int page = 1;

  getPopularMovie() {
    page = 1;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    popularController.sink.add(rv);

    SharedPref.getData(key: SharedPref.popular).then((r) {
      if (r != null) {
        MovieOb ob = MovieOb.fromJson(json.decode(r));
        rv.message = MsgState.data;
        rv.data = ob.results;
        popularController.sink.add(rv);
      }
    });

    getRequest(endUrl: POPULAR_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        SharedPref.setData(
            key: SharedPref.popular, value: resp.data.toString());
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        popularController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        popularController.sink.add(rv);
      }
    });
  }

  getMorePopularMovie() {
    page++;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    morePopularController.sink.add(rv);

    getRequest(endUrl: POPULAR_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        morePopularController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        morePopularController.sink.add(rv);
      }
    });
  }

  void dispose() {
    popularController.close();
    morePopularController.close();
  }
}
