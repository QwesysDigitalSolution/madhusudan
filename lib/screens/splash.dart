import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/animation/FadeAnimation.dart';
import 'package:madhusudan/common/Constants.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(session.Member_Id);
      if (MemberId != null && MemberId != "") {
        if (Platform.isIOS) {
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
            _firebaseMessaging.getToken().then((String token) {
              print("FCM Token : $token");
              checkMemberFCM(token);
            });
          });
          _firebaseMessaging
              .requestNotificationPermissions(IosNotificationSettings());
        } else {
          _firebaseMessaging.getToken().then((String token) {
            print("FCM Token : $token");
            checkMemberFCM(token);
          });
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
      //Navigator.pushReplacementNamed(context, '/login');
    });
  }

  checkMemberFCM(String fcmToken) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        FormData formData = new FormData.fromMap({"UserId": MemberId});
        Services.PostServiceForSave("wl/v1/GetMemberFCMToken", formData).then(
            (data) async {
          if (data.Data == fcmToken) {
            Navigator.pushReplacementNamed(context, '/Dashboard');
          } else {
            prefs.clear();
            Navigator.pushReplacementNamed(context, '/login');
          }
        }, onError: (e) {
          prefs.clear();
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        //showMsg("No Internet Connection.");
        prefs.clear();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on SocketException catch (_) {
      //showMsg("No Internet Connection.");
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Image.asset(
              "images/splashbg.jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            FadeAnimation(
              3,
              Container(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        "images/logo.png",
                        fit: BoxFit.contain,
                        //height: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
