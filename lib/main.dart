import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/StateContainer.dart';
import 'package:madhusudan/screens/AboutUs.dart';
import 'package:madhusudan/screens/ContactUs.dart';
import 'package:madhusudan/screens/OTPScreen.dart';
import 'package:madhusudan/screens/UploadPhotoOrder.dart';

//screen list
import 'package:madhusudan/screens/EditProfile.dart';
import 'package:madhusudan/screens/Splash.dart';
import 'package:madhusudan/screens/Dashboard.dart';
import 'package:madhusudan/screens/Login.dart';
import 'package:madhusudan/screens/MyCart.dart';
import 'package:madhusudan/screens/OrderSuccess.dart';
import 'package:madhusudan/screens/MyOrder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(EasyLocalization(
    child: new StateContainer(
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    setSecuraeMode();
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage");
      print(message);
    }, onResume: (Map<String, dynamic> message) {
      print("onResume");
      print(message);
    }, onLaunch: (Map<String, dynamic> message) {
      print("onLaunch");
      print(message);
    });

    //For Ios Notification
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Setting reqistered : $settings");
    });

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  setSecuraeMode() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future onSelectNotification(String payload) async {
    debugPrint("payload : $payload");
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: cnst.app_primary_material_color[900]
    ));*/
    var data = EasyLocalizationProvider.of(context).data;

    final textTheme = Theme.of(context).textTheme;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Madhusudan",
        initialRoute: '/',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalizationDelegate(
            locale: data.locale,
            path: 'resources/langs',
          ),
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('gu', 'IN')
          /*Locale('gu', 'IN'),
          Locale('mr', 'IN')*/
        ],
        locale: data.locale,
        routes: {
          '/': (context) => splash(),
          '/login': (context) => Login(),
          '/Dashboard': (context) => Dashboard(),
          '/UploadPhotoOrder': (context) => UploadPhotoOrder(),
          '/EditProfile': (context) => EditProfile(),
          '/MyCart': (context) => MyCart(),
          '/OrderSuccess': (context) => OrderSuccess(),
          '/MyOrder': (context) => MyOrder(),
          '/ContactUs': (context) => ContactUs(),
          '/AboutUs': (context) => AboutUs(),
          '/OTPScreen': (context) => OTPScreen(),
        },
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
            body1: GoogleFonts.oswald(textStyle: textTheme.body1),
          ),
          primaryColor: cnst.app_primary_material_color,
          primarySwatch: cnst.app_primary_material_color,
        ),
      ),
    );
  }
}
