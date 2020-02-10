import 'dart:io';

import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List list = new List();
  bool isLoading = true;

  ProgressDialog pr;

  @override
  void initState() {
    getCMS();
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


  getCMS() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(session.Member_Id);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await showPrDialog();
        pr.show();
        List formData = [];
        setState(() {
          isLoading = true;
        });

        Services.GetServiceForList("wl/v1/GetAboutUs", formData).then((data) async {
          if (data.length > 0) {
            pr.hide();
            setState(() {
              list = data;
              isLoading = false;
            });
          } else {
            pr.hide();
            setState(() {
              list.clear();
              isLoading = false;
            });
          }
        }, onError: (e) {
          pr.hide();
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

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.app_primary_material_color),
              ),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.app_primary_material_color,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'About Us',
          style: TextStyle(
              color: cnst.app_primary_material_color,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? Container()
          : list.length > 0
              ? Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                list[index]["Title"],
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                list[index]["Description"],
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ));
                    },
                  ),
                )
              : NoDataComponent(),
    );
  }
}
