import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Constants.dart';
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/MyOrderItem.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String MemberId = "0";
  bool isLoading = false;
  List CurrentOrderList;
  List DeliverdOrderList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
    });

    getPendingOrderDetail();
  }

  getPendingOrderDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId},
          {"key": "Status", "value": "Pending"}
        ];
        print("GetSubCategory Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("wl/v1/GetOrderByType", formData).then(
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
    }
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
        body: TabBarView(
          children: [
            CurrentOrderList != null && CurrentOrderList.length > 0
                ? ListView.builder(
                    itemCount: CurrentOrderList.length,
                    //shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return MyOrderItem(
                        CurrentOrderList[index],
                        "Pending",
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
            DeliverdOrderList != null && DeliverdOrderList.length > 0
                ? ListView.builder(
                    itemCount: DeliverdOrderList.length,
                    //shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return MyOrderItem(
                        DeliverdOrderList[index],
                        "Delivered",
                        ((String action) {
                          if (action == "OrderCancel") {
                            setState(() {
                              DeliverdOrderList.removeAt(index);
                            });
                          }
                        }),
                      );
                    })
                : NoDataComponent(),
          ],
        ),
      ),
    );
  }
}
