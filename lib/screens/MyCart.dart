import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/common/StateContainer.dart';
import 'package:madhusudan/component/MyCartItem.dart';
import 'package:madhusudan/screens/CheckOut.dart';
import 'package:madhusudan/utils/Shimmer.dart';
import 'package:progress_dialog/progress_dialog.dart';
/*import 'package:madhusudan/screens/StateContainer.dart';*/
import 'package:shared_preferences/shared_preferences.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  String MemberId = "0";
  bool isLoading = false;
  List CartList = [];
  double subTotal = 0;
  double discount = 0;
  double totalAmt = 0;
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

    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Gender = prefs.getString(cnst.session.Gender);
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
    });

    getOrderDetail();
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

  getOrderDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId}
        ];
        print("GetMyCart Data = ${formData}");
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("wl/v1/GetMyCart", formData).then(
            (data) async {
          if (data.length > 0) {
            setState(() {
              CartList = data;
            });
            CalculateTotal();
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
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  CalculateTotal() async {
    setState(() {
      subTotal = 0;
      discount = 0;
      totalAmt = 0;
    });
    print("CalculateTotal");
    if (CartList.length > 0) {
      for (int i = 0; i < CartList.length; i++) {
        setState(() {
          totalAmt += (double.parse(CartList[i]["Mrp"].toString()) *
              double.parse(CartList[i]["Qty"].toString()));
        });
      }
    } else {
      setState(() {
        totalAmt = 0;
      });
    }
  }

  UpdateCartCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({"UserId": MemberId});
        print("getItemDetails Data = ${formData}");
        //pr.show();
        /*setState(() {
          isLoading = true;
        });*/
        Services.PostServiceForSave("wl/v1/GetCartCount", formData).then(
            (data) async {
          if (data.IsSuccess == true) {
            final myInheritaedWidget = StateContainer.of(context);
            myInheritaedWidget.updateCartData(
              cartCount: int.parse(data.Data.toString()),
            );
            /*setState(() {
              isLoading = false;
            });*/
          } else {
            showMsg(data.Message);
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

  void removeCartItem(index) async {
    try {
      await showPrDialog();
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Id": CartList[index]["CartId"].toString(),
          "UserId": MemberId,
        });
        print("RemoveCartItem Data = ${formData}");
        Services.PostServiceForSave("wl/v1/RemoveCartItem", formData).then(
            (data) async {
          pr.hide();
          if (data.Data == "1") {
            showMsg("Product Removed Successfully.");
            setState(() {
              CartList.removeAt(index);
            });
            CalculateTotal();
            UpdateCartCount();
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  void updateCartList(qty, index) async {
    try {
      await showPrDialog();
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "UserId": MemberId,
          "Id": CartList[index]["CartId"].toString(),
          "Qty": qty.toString(),
        });

        print("UpdateCartItem Data = ${formData}");
        Services.PostServiceForSave("wl/v1/UpdateCartItem", formData).then(
            (data) async {
          pr.hide();
          if (data.Data == "1") {
            CalculateTotal();
            //UpdateCartCount();
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: TextStyle(color: cnst.app_primary_material_color),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, "");
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: cnst.app_primary_material_color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? ShimmerCardListSkeleton(length: 5, isCircularImage: false)
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 200,
                    margin: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: CartList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MyCartItem(
                          index: index,
                          product: CartList[index],
                          removeItem: removeCartItem,
                          updateItemList: updateCartList,
                        );
                        /*MyCartItem(
                    onItemDelete,
                    CartList[index],
                    ((var data) {
                      if (data["status"] == "ProductRemoved") {
                        setState(() {
                          CartList.removeAt(index);
                        });
                      }
                      CalculateTotal();
                      UpdateCartCount();
                    }),
                  );*/
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "TOTAL",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            Text(
                              cnst.inr_rupee + " ${totalAmt}",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                            ),
                          ],
                        ),
                        Container(
                          width: 165,
                          //margin: EdgeInsets.only(top: 20),
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                            color: cnst.app_primary_material_color[600],
                            //minWidth: MediaQuery.of(context).size.width - 20,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckOut(CartList),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "CHECKOUT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    //shape: BoxShape.circle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color:
                                          cnst.app_primary_material_color[600],
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
