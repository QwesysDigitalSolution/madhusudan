import 'dart:io';

import 'package:flutter/material.dart';
import 'package:madhusudan/common/Services.dart';

// Component List
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:madhusudan/component/NotificationComponent.dart';
import 'package:madhusudan/utils/Shimmer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;

class NotificationScrren extends StatefulWidget {
  @override
  _NotificationScrrenState createState() => _NotificationScrrenState();
}

class _NotificationScrrenState extends State<NotificationScrren> {
  var notification = {
    "Title": "Title",
    "Description": "Description Data",
    "Date": "2020-01-04 18:55:00"
  };
  List list = new List();
  bool isLoading = true;

  ProgressDialog pr;

  @override
  void initState() {
    getNoti();
  }

  showPrDialog() async {
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

  getNoti() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await showPrDialog();

        List formData = [
          {"key": "UserId", "value": MemberId},
        ];
        setState(() {
          isLoading = true;
        });

        Services.GetServiceForList("wl/v1/GetNotificationData", formData).then(
            (data) async {
          if (data.length > 0) {
            setState(() {
              list = data;
              isLoading = false;
            });
          } else {
            setState(() {
              list.clear();
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            list.clear();
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        list.clear();
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ShimmerCardListSkeleton(length: 5, isImage: false)
        : list.length > 0
            ? Container(
                padding: EdgeInsets.all(0),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NotificationComponent(list[index]);
                  },
                ),
              )
            : NoDataComponent();
  }
}
