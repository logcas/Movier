import 'package:flutter/material.dart';
import '../components/drawer.dart';
import '../components/movieList.dart';

AppBar indexAppBar() {
  return AppBar(
    title: Text('查票票'),
    leading: Builder(builder: (context) {
      return IconButton(
        icon: Icon(
          Icons.dashboard,
          color: Colors.white,
        ),
        onPressed: () {
          print('点击了appbar icon button');
        },
      );
    }),
  );
}

class IndexScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexScaffoldState();
  }
}

class _IndexScaffoldState extends State<IndexScaffold> {
  int _selectedIndex = 0;
  String _hotMovieUrl =
      'https://api-m.mtime.cn/Showtime/LocationMovies.api?locationId=290';
  String _commingMovieUrl =
      'https://api-m.mtime.cn/Movie/MovieComingNew.api?locationId=290';
  final _pageViewController = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageViewController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    _pageViewController.addListener(() {
      print(_pageViewController.page);
      // setState(() {
      //   _selectedIndex = _pageViewController.page.floor();
      // });
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('查电影'),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.movie), title: Text('正在热映')),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_movies), title: Text('即将上映')),
            BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text('关于'))
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        drawer: IndexDrawer(),
        body: PageView(
          onPageChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          controller: _pageViewController,
          children: <Widget>[
            MovieListPage(_hotMovieUrl, 'ms'),
            MovieListPage(_commingMovieUrl, 'moviecomings'),
            // Center(
            //   child: Text('1111'),
            // ),
            // Center(
            //   child: Text('2222'),
            // ),
            Center(
              child: Text('3333'),
            )
          ],
        ));
  }
}
