import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madhusudan/common/ClassList.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/StateContainer.dart';

//Screens List
import 'package:madhusudan/screens/Home.dart';
import 'package:madhusudan/screens/Notification.dart';
import 'package:madhusudan/screens/Profile.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CartData cartData = new CartData();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";


  List<String> menu_list = ["Dashboard", "Notification", "Profile"];
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
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
            print("FFFFFFFF" + data.toString());
            saveDeviceToken();
          });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }
  }
  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      setState(() {
        fcmToken = token;
        //sendFCMTokan(token);
      });
      print("FCM Token : $fcmToken");
    });
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cnst.app_primary_material_color[900],
    ));

    final myInheritaedWidget = StateContainer.of(context);
    cartData = myInheritaedWidget.cartData;

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
      appBar: AppBar(
        title: Text(
          "${menu_list[_currentIndex]}",
          style: TextStyle(
            color: cnst.app_primary_material_color,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/MyCart');
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, right: 15, bottom: 10),
                  child: Center(
                      child: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: cnst.app_primary_material_color,
                  )),
                ),
                Container(
                  //width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 4, left: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "${cartData != null ? cartData.CartCount : 0}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
