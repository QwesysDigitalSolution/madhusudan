import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madhusudan/common/ClassList.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/common/StateContainer.dart';
import 'package:firebase_database/firebase_database.dart';

//Screens List
import 'package:madhusudan/screens/Home.dart';
import 'package:madhusudan/screens/Notification.dart';
import 'package:madhusudan/screens/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DBRfef = FirebaseDatabase.instance.reference();
  CartData cartData = new CartData();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";
  String MemberId = "0";

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
    //Firebase DB
    if (Platform.isIOS) {
      _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        setFirebase();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      setFirebase();
    }
    UpdateCartCount();
  }

  UpdateCartCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "UserId": MemberId
        });
        print("getItemDetails Data = ${formData}");
        //pr.show();
        /*setState(() {
          isLoading = true;
        });*/
        Services.PostServiceForSave("wl/v1/GetCartCount", formData).then(
                (data) async {
              if (data.IsSuccess == true) {
                final myInheritaedWidget = StateContainer.of(context);
                myInheritaedWidget.updateCartData(
                  cartCount: int.parse(data.Data),
                );
                /*setState(() {
                  isLoading = false;
                });*/
              } else {
                showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
          /*setState(() {
            isLoading = false;
          });*/
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  setFirebase() async {
    //Local Data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
    });

    //Get FCM Token & Set Value To FirebaseDB
    _firebaseMessaging.getToken().then((String token) {
      print("FCM Token : $token");
      setState(() {
        fcmToken = token;
      });
      DBRfef.child(MemberId).once().then((DataSnapshot dataSnapshot) {
        print("Data Value On Load : ${dataSnapshot.value}");
        if (dataSnapshot.value == null)
          DBRfef.child(MemberId).set({"Token": token.toString()});
        else if (dataSnapshot.value != token)
          DBRfef.child(MemberId).update({"Token": token.toString()});
      });
    });

    //On Child Value Change
    DBRfef.child(MemberId).onChildChanged.listen((Event event) async {
      print("DB Value Change : " + event.snapshot.value.toString());
      String newToken = event.snapshot.value.toString();
      if (newToken != fcmToken) {
        await prefs.clear();
        Fluttertoast.showToast(
          msg: "User Login To New Device !",
          fontSize: 18,
          backgroundColor: Colors.black,
          gravity: ToastGravity.TOP,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 5,
        );
        Navigator.pushReplacementNamed(context, "/login");
      }
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
    final myInheritaedWidget = StateContainer.of(context);
    cartData = myInheritaedWidget.cartData;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cnst.app_primary_material_color[900],
    ));

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
