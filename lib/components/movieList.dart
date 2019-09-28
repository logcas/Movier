import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

List<Widget> generateComingMovieList(context, movies) {
  List<Widget> li = [];
  for (int i = 0; i < movies.length; ++i) {
    var mo = movies[i];
    li.insert(
      li.length,
      Card(
        margin: i == movies.length - 1
            ? EdgeInsets.all(0)
            : EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'detail',
                arguments: {'id': mo['id'].toString(), 'name': mo['title']});
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: NetworkImage(mo['image']),
                  width: 70.0,
                  height: 100.0,
                ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    constraints: BoxConstraints.tightFor(width: 240),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          mo['title'],
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.blue),
                          textScaleFactor: 1.3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              mo['wantedCount'].toString(),
                              style: TextStyle(color: Colors.orangeAccent),
                              textScaleFactor: 1.3,
                            ),
                            Text(
                              '人想看',
                              style: TextStyle(color: Colors.black26),
                              textScaleFactor: 0.9,
                            ),
                          ],
                        ),
                        Text(
                          '主演: ${mo['actor1']}, ${mo['actor2']}',
                          style: TextStyle(color: Colors.black45),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${mo['locationName']}${mo['releaseDate']}',
                          style: TextStyle(color: Colors.black45),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return li;
}

List<Widget> generateMovieList(context, movies) {
  List<Widget> li = [];
  for (int i = 0; i < movies.length; ++i) {
    var mo = movies[i];
    li.insert(
      li.length,
      Card(
        margin: i == movies.length - 1
            ? EdgeInsets.all(0)
            : EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'detail',
                arguments: {'id': mo['id'].toString(), 'name': mo['t']});
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: NetworkImage(mo['img']),
                  width: 70.0,
                  height: 100.0,
                ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    constraints: BoxConstraints.tightFor(width: 240),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          mo['t'],
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.blue),
                          textScaleFactor: 1.3,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '评分',
                                  style: TextStyle(color: Colors.black26),
                                  textScaleFactor: 0.9,
                                ),
                                Text(
                                  mo['r'] > 0 ? mo['r'].toString() : '暂无',
                                  style: TextStyle(color: Colors.orangeAccent),
                                  textScaleFactor: 1.3,
                                )
                              ],
                            )
                          ],
                        ),
                        Text(
                          '主演: ${mo['aN1']}, ${mo['aN2']}',
                          style: TextStyle(color: Colors.black45),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '今天${mo['NearestCinemaCount']}个影院放映${mo['NearestShowtimeCount']}场',
                          style: TextStyle(color: Colors.black45),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return li;
}

class MovieListPage extends StatefulWidget {
  String _url = '';
  String meta = '';
  MovieListPage(this._url, this.meta);

  @override
  State<StatefulWidget> createState() {
    return _MovieListPageState(_url, meta);
  }
}

class _MovieListPageState extends State<MovieListPage>
    with AutomaticKeepAliveClientMixin {
  String _url = '';
  String _meta = '';
  Future<List> _future;

  _MovieListPageState(this._url, this._meta);

  @override
  void initState() {
    super.initState();
    _future = fetchHotPlayingMovies();
  }

  Future<List> fetchHotPlayingMovies() async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(_url));
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    return Future<List>.value(data[_meta]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('请求数据出错');
          } else {
            return Container(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10),
                children: _meta == 'ms'
                    ? generateMovieList(context, snapshot.data)
                    : generateComingMovieList(context, snapshot.data),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    // return Container(
    //   child: _loading
    //       ? Center(
    //           child: Text('正在获取数据...'),
    //         )
    //       : ListView(
    //           physics: BouncingScrollPhysics(),
    //           padding: EdgeInsets.all(10),
    //           children: _meta == 'ms'
    //               ? generateMovieList(_movieData)
    //               : generateComingMovieList(_movieData),
    //         ),
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
