import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:madhusudan/Common/Constants.dart';
import 'package:madhusudan/Component/LoadingComponent.dart';
import 'package:madhusudan/component/MyOrderItem.dart';
import 'package:madhusudan/Component/NoDataComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String MemberId = "0";
  bool isLoading = false;
  List CurrentOrderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    String Gender = prefs.getString(Session.Gender);
    setState(() {
      MemberId = prefs.getString(Session.MemberId);
    });

    getOrderDetail();*/
  }

  getOrderDetail() async {
    /*try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId}
        ];
        print("GetSubCategory Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("GetCurrentOrder", formData).then(
                (data) async {
              if (data.length > 0) {
                setState(() {
                  CurrentOrderList = data;
                });
                setState(() {
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            }, onError: (e) {
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }*/
  }

  showMsg(String msg, {String title = 'Kaya Cosmetics'}) {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Orders",
              style: TextStyle(color: cnst.app_primary_material_color)),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: cnst.app_primary_material_color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            indicatorColor: cnst.app_primary_material_color,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text("Pending Order",
                    style: TextStyle(fontSize: 17, color: Colors.black)),
              ),
              Text("Delivered Order",
                  style: TextStyle(fontSize: 17, color: Colors.black)),
            ],
          ),
        ),
        body: TabBarView(children: [
          CurrentOrderList != null && CurrentOrderList.length > 0
              ? ListView.builder(
                  itemCount: CurrentOrderList.length,
                  //shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return MyOrderItem(
                      CurrentOrderList[index],
                      ((String action) {
                        if (action == "OrderCancel") {
                          setState(() {
                            CurrentOrderList.removeAt(index);
                          });
                        }
                      }),
                    );
                  })
              : NoDataComponent(),
          CurrentOrderList != null && CurrentOrderList.length > 0
              ? ListView.builder(
              itemCount: CurrentOrderList.length,
              //shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return MyOrderItem(
                  CurrentOrderList[index],
                  ((String action) {
                    if (action == "OrderCancel") {
                      setState(() {
                        CurrentOrderList.removeAt(index);
                      });
                    }
                  }),
                );
              })
              : NoDataComponent(),
        ]),
      ),
    );
  }
}
