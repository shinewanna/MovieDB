import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shell/ob/movie_ob.dart';
import 'package:flutter_shell/utils/app_constants.dart';

class DescriptionScreen extends StatefulWidget {
  final Results result;
  DescriptionScreen({this.result}) : super();

  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        widget.result.backdropPath != null
            ? Container(
                alignment: Alignment.topCenter,
                child: CachedNetworkImage(
                  imageUrl: MOVIE_BASE_URL + widget.result.backdropPath,
                  placeholder: (context, url) => Container(
                    width: 200,
                    height: 200,
                    child: new Image.asset(
                      "images/loading.gif",
                      fit: BoxFit.cover,
                    ),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              )
            : Container(),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
              width: double.infinity,
              height: h - (h / 3.5),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 180,
                        ),
                        Flexible(
                          child: Text(
                            widget.result.title,
                            overflow: TextOverflow.clip,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 180,
                        ),
                        Container(
                          height: 20,
                          width: 55,
                          child: OutlineButton(
                            onPressed: null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                widget.result.voteAverage,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Overview",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.result.overview,
                              overflow: TextOverflow.clip,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Release Date: " + widget.result.releaseDate,
                              overflow: TextOverflow.clip,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        widget.result.posterPath != null
            ? Container(
                alignment: Alignment(-0.7, -0.6),
                child: Container(
                  height: 170,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: MOVIE_BASE_URL + widget.result.posterPath,
                      placeholder: (context, url) =>
                          new Image.asset("images/loading.gif"),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : Container()
      ],
    ));
  }
}
