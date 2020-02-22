import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Constants.dart';
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/MyOrderItem.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/utils/Shimmer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madhusudan/component/MyDeliverdOrderItem.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String MemberId = "0";
  bool isLoading = false;
  List CurrentOrderList;
  List PhotoOrderList;
  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
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
          color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
    );
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
    });

    await getPendingOrderDetail();
    await getDeliverdOrderDetail();
  }

  getPendingOrderDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId},
          {"key": "Status", "value": "Order"}
        ];
        print("GetSubCategory Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("wl/v1/GetOrderByTypeNew", formData).then(
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

  getDeliverdOrderDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId},
          {"key": "Status", "value": "PhotoOrder"}
        ];
        print("GetSubCategory Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("wl/v1/GetOrderByTypeNew", formData).then(
            (data) async {
          if (data.length > 0) {
            setState(() {
              PhotoOrderList = data;
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

  void OrderCancel(orderId, index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      await showPrDialog();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        FormData formData =
            new FormData.fromMap({"UserId": MemberId, "OrderId": orderId});

        Services.PostServiceForSave("wl/v1/CancelOrder", formData).then(
            (data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            setState(() {
              CurrentOrderList.removeAt(index);
            });
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Orders",
            style: TextStyle(
              color: cnst.app_primary_material_color,
            ),
          ),
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
                child: Text("Orders",
                    style: TextStyle(fontSize: 17, color: Colors.black)),
              ),
              Text("Photo Orders",
                  style: TextStyle(fontSize: 17, color: Colors.black)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoading
                ? ShimmerCardListSkeleton(
                    length: 5,
                    isCircularImage: false,
                  )
                : CurrentOrderList != null && CurrentOrderList.length > 0
                    ? ListView.builder(
                        itemCount: CurrentOrderList.length,
                        //shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return MyOrderItem(
                            index: index,
                            order: CurrentOrderList[index],
                            onCancel: OrderCancel,
                          );
                        })
                    : NoDataComponent(),
            isLoading
                ? ShimmerCardListSkeleton(
                    length: 5,
                    isCircularImage: false,
                  )
                : PhotoOrderList != null && PhotoOrderList.length > 0
                    ? ListView.builder(
                        itemCount: PhotoOrderList.length,
                        //shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return MyDeliverdOrderItem(
                            PhotoOrderList[index],
                          );
                        })
                    : NoDataComponent(),
          ],
        ),
      ),
    );
  }
}
