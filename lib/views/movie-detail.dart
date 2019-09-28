import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class MovieDetailPage extends StatelessWidget {
  Future<Map> getMovieDetail(String id) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(
        'https://ticket-api-m.mtime.cn/movie/detail.api?locationId=290&movieId=$id'));
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    return Future<Map>.value(data['data']);
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: FutureBuilder(
        future: getMovieDetail(args['id']),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('请求数据出错'),
              );
            } else {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    snap: false,
                    expandedHeight: 200,
                    backgroundColor: Colors.blue,
                    title: Text(args['name']),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        snapshot.data['basic']['img'],
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 100,
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image:
                                  NetworkImage(snapshot.data['basic']['img']),
                              width: 70.0,
                              height: 100.0,
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                constraints:
                                    BoxConstraints.tightFor(width: 240),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data['basic']['name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.blue),
                                      textScaleFactor: 1.3,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data['boxOffice']['totalBoxUnit'],
                                              style: TextStyle(
                                                  color: Colors.black26),
                                              textScaleFactor: 0.9,
                                            ),
                                            Text(
                                              snapshot.data['boxOffice']
                                                  ['totalBoxDes'],
                                              style: TextStyle(
                                                  color: Colors.orangeAccent),
                                              textScaleFactor: 1.3,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      '主演: ${snapshot.data['basic']['actors'][0]['name']}',
                                      style: TextStyle(color: Colors.black45),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      );
                    }, childCount: 1),
                  )
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
