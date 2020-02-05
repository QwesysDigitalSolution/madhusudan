import 'dart:async';
import 'package:flutter/services.dart';
import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/animation/FadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*String MemberId = prefs.getString(Session.MemberId);
      String veri = prefs.getString(Session.IsVerified);

      if (MemberId != null && MemberId != "" && veri=="true") {
        controller.stop(canceled: true);
        Navigator.pushReplacementNamed(context, '/Dashboard');
      } else {
        controller.stop(canceled: true);
        Navigator.pushReplacementNamed(context, '/Login');
      }*/
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
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
