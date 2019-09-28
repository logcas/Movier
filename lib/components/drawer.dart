import 'package:flutter/material.dart';

class IndexDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Padding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Text(
                    'test',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      FlatButton(
                        child: ListTile(
                          leading: Icon(Icons.add),
                          title: Text('增加城市'),
                        ),
                        onPressed: () {
                          print('增加城市');
                        },
                      ),
                      FlatButton(
                        child: ListTile(
                          leading: Icon(Icons.search),
                          title: Text('切换城市'),
                        ),
                        onPressed: () {
                          print('切换城市');
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            padding: EdgeInsets.only(top: 30.0),
          )),
    );
  }
}
