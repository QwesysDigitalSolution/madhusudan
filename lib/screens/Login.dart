import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/animation/FadeAnimation.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController edtMobile = new TextEditingController();

  double widt;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                cnst.app_primary_material_color),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));

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

  _checkLogin() async {
    if (edtMobile.text != "") {
      if (edtMobile.text.length == 10) {
        try {

          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            pr.show();
            List formData = [
              {"key": "MobileNo", "value": edtMobile.text},
              {"key": "FCMToken", "value": fcmToken},
            ];
            Future res =
            Services.GetServiceForList("wl/v1/GetLoginData", formData);
            res.then((data) async {
              pr.hide();
              if (data != null && data.length > 0) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    cnst.session.Member_Id, data[0]["Id"].toString());
                await prefs.setString(cnst.session.Email, data[0]["Email"]);
                await prefs.setString(cnst.session.Name, data[0]["Name"]);
                  await prefs.setString(cnst.session.Image, data[0]["Image"]);
                await prefs.setString(cnst.session.Mobile, data[0]["Mobile"]);
                await prefs.setString(cnst.session.Address, data[0]["Address"]);
                await prefs.setString(
                    cnst.session.IsVerified, data[0]["IsVerified"].toString());

                /*if (data[0]["IsVerified"].toString().toLowerCase() == "true") {
                  Navigator.pushReplacementNamed(context, '/Dashboard');
                } else {
                  Navigator.pushReplacementNamed(context, '/OTPScreen');
                }*/

                Navigator.pushReplacementNamed(
                    context, '/Dashboard');
              } else {
                showMsg("Mobile Number is Incorrect");
              }
            }, onError: (e) {
              pr.hide();
              showMsg("Try Again.");
            });
          }/* else {
            pr.isShowing()?pr.hide():null;
            showMsg("No Internet Connection.");
          }*/
        } on SocketException catch (_) {
          pr.isShowing()?pr.hide():null;
          showMsg("No Internet Connection.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Enter Valid Mobile Number.",
            fontSize: 13,
            backgroundColor: Colors.redAccent,
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Enter Mobile Number.",
          fontSize: 13,
          backgroundColor: Colors.redAccent,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cnst.app_primary_material_color[900],
    ));

    double widt = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
              1,
              Padding(
                padding: EdgeInsets.only(
                    bottom: widt * 0.20, left: widt * 0.10, right: widt * 0.10),
                child: Image.asset(
                  "images/logo.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        2,
                        TextFormField(
                          controller: edtMobile,
                          cursorColor: Theme.of(context).cursorColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            //fillColor: Colors.white,
                            counterText: "",
                            filled: true,
                            hintText: 'Enter Mobile No',
                            labelText: "Mobile No",
                            prefixIcon: Icon(
                              Icons.phone_iphone,
                              color: Colors.grey,
                            ),
                            //helperText: "password",
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      FadeAnimation(
                        2.5,
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 20),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                            color: cnst.app_primary_material_color[600],
                            minWidth: MediaQuery.of(context).size.width - 20,
                            onPressed: () {
                              _checkLogin();
                              //Navigator.pushReplacementNamed(context, '/Dashboard');
                              /*Navigator.pushReplacementNamed(
                                  context, '/Dashboard');*/

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    //shape: BoxShape.circle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.transparent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    //shape: BoxShape.circle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: cnst.app_primary_material_color,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
