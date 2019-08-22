import 'package:flutter/widgets.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shell/utils/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_shell/view/page/description_page/description_screen.dart';

viewWidget(BuildContext context, Results result) {
  return result.backdropPath == null
      ? Container()
      : Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 170,
                width: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DescriptionScreen(
                                    result: result,
                                  )));
                    },
                    child: CachedNetworkImage(
                      imageUrl: MOVIE_BASE_URL + result.posterPath,
                      placeholder: (context, url) =>
                          new Image.asset("images/loading.gif"),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              result.title.length > 19
                  ? Text(
                      '${result.title.substring(0, 18)}\n${result.title.substring(18, result.title.length)}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      result.title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    height: 20,
                    width: 55,
                    child: OutlineButton(
                      onPressed: null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          result.voteAverage,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ));
}
