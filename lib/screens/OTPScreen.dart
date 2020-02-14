import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:madhusudan/Common/Constants.dart';
import 'package:madhusudan/Common/Services.dart';
import 'package:madhusudan/Component/LoadingComponent.dart';
import 'package:flutter/material.dart';

import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madhusudan/common/Constants.dart';

import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController edtMobile = new TextEditingController();
  TextEditingController controller = TextEditingController();

  var isLoading = false;
  int otpCode;

  String memberId = "", memberMobile = "";

  ProgressDialog pr;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";

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
    sendOtp();
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

  showInternetMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  sendOtp() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var rng = new Random();
        int code = rng.nextInt(9999 - 1000) + 1000;
        print(code.toString());
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();

        memberId = prefs.getString(cnst.session.Member_Id);
        memberMobile = prefs.getString(cnst.session.Mobile);

        FormData formData = new FormData.fromMap(
            {"MobileNo": prefs.getString(cnst.session.Mobile), "Code": code});

        Services.PostServiceForSave("wl/v1/SendOtp", formData).then(
            (data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            setState(() {
              otpCode = code;
            });
            Fluttertoast.showToast(
                msg: "Otp Send ${data.Message}",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call");
          //showMsg("$e");
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
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

  VerificationStatusUpdate() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String MemberId = prefs.getString(cnst.session.Member_Id);

        List formData = [
          {"key": "UserId", "value": MemberId},
          {"key": "FCMToken", "value": fcmToken},
        ];
        Services.GetServiceForSave("wl/v1/OtpVerification", formData).then(
            (data) async {
          pr.hide();
          if (data.Data == "1" && data.IsSuccess == true) {
            await prefs.setString(cnst.session.IsVerified, "true");
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Dashboard', (Route<dynamic> route) => false);
          } else {
            pr.hide();
          }
        }, onError: (e) {
          pr.hide();
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.9,
                  color: cnst.app_primary_material_color.withOpacity(0.9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Verify Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Text(
                          "OTP has been sent to you on ${memberMobile}. Please enter it below",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      //side: BorderSide(color: cnst.appcolor)),
                      side: BorderSide(width: 0.50, color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.65,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      //color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: PinCodeTextField(
                              autofocus: false,
                              controller: controller,
                              //hideCharacter: true,
                              highlight: true,
                              pinBoxHeight: 60,
                              pinBoxWidth: 60,
                              highlightColor: cnst.app_primary_material_color,
                              defaultBorderColor: Colors.grey,
                              hasTextBorderColor:
                                  cnst.app_primary_material_color,
                              maxLength: 4,
                              //hasError: hasError,
                              //maskCharacter: "😎",
                              /*pinCodeTextFieldLayoutType:
                                  PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,*/
                              pinBoxDecoration: ProvidedPinBoxDecoration
                                  .defaultPinBoxDecoration,
                              pinTextStyle: TextStyle(fontSize: 20.0),
                              pinTextAnimatedSwitcherTransition:
                                  ProvidedPinBoxTextAnimation.scalingTransition,
                              pinTextAnimatedSwitcherDuration:
                                  Duration(milliseconds: 200),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 30),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              color: cnst.app_primary_material_color,
                              minWidth: MediaQuery.of(context).size.width - 20,
                              onPressed: () {
                                if (controller.text != "") {
                                  if (otpCode.toString() == controller.text) {
                                    VerificationStatusUpdate();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Enter Valid Code",
                                        backgroundColor: Colors.green,
                                        gravity: ToastGravity.TOP,
                                        toastLength: Toast.LENGTH_SHORT);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Enter Otp",
                                      backgroundColor: Colors.green,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Text(
                                "VERIFY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  Text(
                                    "Didn't Receive the Verification Code ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //print("tap");
                                      if (!isLoading) {
                                        sendOtp();
                                      }
                                    },
                                    child: Text(
                                      'RESEND CODE',
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              cnst.app_primary_material_color),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: isLoading ? LoadingComponent() : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
