import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Constants.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/screens/OrderDetail.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderItem extends StatefulWidget {
  var order;
  String status;
  Function onchange;

  MyOrderItem(this.order, this.status, this.onchange);

  @override
  _MyOrderItemState createState() => _MyOrderItemState();
}

class _MyOrderItemState extends State<MyOrderItem> {
  List productList;
  ProgressDialog pr;

  @override
  void initState() {
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

    super.initState();

    setState(() {
      productList = widget.order["ItemsList"];
    });
  }

  OrderCancel() async {
    /*try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        var formData = {"UserId": MemberId, "OrderId": widget.order["Id"]};

        Services.PostServiceForSave("CancelOrder", formData).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            widget.onchange("OrderCancel");
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetail(
              widget.order,
              "pending",
            ),
          ),
        );
      },
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Order No ${widget.order["Id"]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 3),
                child: Text(
                  "${widget.order["Date"].toString().substring(0, 10)}",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: (productList[0]["Image"] != null &&
                                productList[0]["Image"] != "")
                            ? Image.network(
                                "${cnst.img_url + productList[0]["Image"]}",
                                height: 90,
                                width: 90,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                height: 90,
                                width: 90,
                                //padding: EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: Text(
                                    'No Image Available',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          "${productList[0]["ItemName"]}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      /*Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          "7, Hot Pink",
                          style: TextStyle(fontSize: 15, color: Colors.black45),
                        ),
                      ),*/
                      Text(
                        cnst.inr_rupee +
                            "${int.parse(productList[0]["Mrp"]) * int.parse(productList[0]["Qty"])}",
                        style: TextStyle(
                            fontSize: 15,
                            color: cnst.app_primary_material_color),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        "Total Amount:  " +
                            cnst.inr_rupee +
                            " ${widget.order["Total"]} /-",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    widget.status == "Pending"
                        ? Container(
                            width: MediaQuery.of(context).size.width / 2.7,
                            height: 35,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    color: cnst.app_primary_material_color)),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0)),
                              color: Colors.white,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title:
                                          new Text("Order Cancel Conformation"),
                                      content: new Text(
                                          "Are you sure you want to cancel this order?"),
                                      actions: <Widget>[
                                        // usually buttons at the bottom of the dialog
                                        new FlatButton(
                                          child: new Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text("Accept"),
                                          onPressed: () {
                                            OrderCancel();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.cancel,
                                    color: cnst.app_primary_material_color,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Cancel Order",
                                      style: TextStyle(
                                          color:
                                              cnst.app_primary_material_color,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
