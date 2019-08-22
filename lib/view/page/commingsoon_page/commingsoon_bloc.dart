import 'dart:convert';

import 'package:flutter_shell/network/base_network.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class CommingSoonBloc extends BaseNetwork {
  PublishSubject<ResponseOb> commingSoonController =
      PublishSubject<ResponseOb>();

  Observable<ResponseOb> commingSoonStream() {
    return commingSoonController.stream;
  }

  PublishSubject<ResponseOb> moreCommingSoonController =
      PublishSubject<ResponseOb>();

  Observable<ResponseOb> moreCommingSoonStream() {
    return moreCommingSoonController.stream;
  }

  static int page = 1;

  getCommingSoonMovie() {
    page = 1;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    commingSoonController.sink.add(rv);

    SharedPref.getData(key: SharedPref.commingsoon).then((r) {
      if (r != null) {
        MovieOb ob = MovieOb.fromJson(json.decode(r));
        rv.message = MsgState.data;
        rv.data = ob.results;
        commingSoonController.sink.add(rv);
      }
    });

    getRequest(endUrl: UPCOMMING_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        SharedPref.setData(
            key: SharedPref.commingsoon, value: resp.data.toString());
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        commingSoonController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        commingSoonController.sink.add(rv);
      }
    });
  }

  getMoreCommingSoonMovie() {
    page++;
    print(page);
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    moreCommingSoonController.sink.add(rv);

    getRequest(endUrl: UPCOMMING_END_URL + '$page').then((resp) {
      if (resp.message == MsgState.data) {
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        moreCommingSoonController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        moreCommingSoonController.sink.add(rv);
      }
    });
  }

  void dispose() {
    commingSoonController.close();
    moreCommingSoonController.close();
  }
}
