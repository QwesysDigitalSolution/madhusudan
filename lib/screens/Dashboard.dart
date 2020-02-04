import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;

//Screens List
import 'package:madhusudan/screens/Home.dart';
import 'package:madhusudan/screens/Notification.dart';
import 'package:madhusudan/screens/Profile.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Widget> _children = [
    Home(),
    NotificationScrren(),
    Profile(),
  ];

  int _currentIndex = 0;
  PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = new PageController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  showMsg(String msg, {String title = 'Madhusudan'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: cnst.app_primary_material_color,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text(
              "Notification",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            title: Text(
              "Profile",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
      ),
      appBar: AppBar(title: Text("Madhusudan")),
      body: _children[_currentIndex],
    );
  }
}
