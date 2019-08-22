import 'dart:convert';

import 'package:flutter_shell/network/base_network.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/ob/response_ob.dart';
import 'package:flutter_shell/shp/shared_pref.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends BaseNetwork {
  PublishSubject<ResponseOb> searchController = PublishSubject<ResponseOb>();

  Observable<ResponseOb> searchStream() {
    return searchController.stream;
  }

  // PublishSubject<ResponseOb> moreSearchController =
  //     PublishSubject<ResponseOb>();

  // Observable<ResponseOb> moreCommingSoonStream() {
  //   return moreSearchController.stream;
  // }

  static int page = 1;

  getSearchMovie(String searchText) {
    page = 1;
    ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
    searchController.sink.add(rv);

    SharedPref.getData(key: SharedPref.commingsoon).then((r) {
      if (r != null) {
        MovieOb ob = MovieOb.fromJson(json.decode(r));
        rv.message = MsgState.data;
        rv.data = ob.results;
        searchController.sink.add(rv);
      }
    });

    getSerchRequest(endUrl: '$searchText' + SEARCH_END_URL + '$page')
        .then((resp) {
      if (resp.message == MsgState.data) {
        SharedPref.setData(
            key: SharedPref.commingsoon, value: resp.data.toString());
        MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
        rv.message = MsgState.data;
        rv.data = ob.results;
        searchController.sink.add(rv);
      } else {
        rv.message = MsgState.error;
        rv.data = resp.data;
        searchController.sink.add(rv);
      }
    });
  }

  // getMoreSearchMovie() {
  //   page++;
  //   ResponseOb rv = ResponseOb(data: null, message: MsgState.loading);
  //   moreSearchController.sink.add(rv);

  //   getRequest(endUrl: UPCOMMING_END_URL + '$page').then((resp) {
  //     if (resp.message == MsgState.data) {
  //       MovieOb ob = MovieOb.fromJson(json.decode(resp.data));
  //       rv.message = MsgState.data;
  //       rv.data = ob.results;
  //       moreSearchController.sink.add(rv);
  //     } else {
  //       rv.message = MsgState.error;
  //       rv.data = resp.data;
  //       moreSearchController.sink.add(rv);
  //     }
  //   });
  // }

  void dispose() {
    searchController.close();
    // moreSearchController.close();
  }
}
