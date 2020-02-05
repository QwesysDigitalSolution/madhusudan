import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/component/MyOrderItem.dart';
import 'package:madhusudan/component/OrderedItem.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class OrderDetail extends StatefulWidget {
  String orderId;
  String status;

  OrderDetail(this.orderId,this.status);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  ProgressDialog pr;
  bool isLoading = false;

  var Order = {};
  List OrderItems = [];
  List OrderStatus = [];
  var OrderShippingAddress = {};

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
            valueColor:
            new AlwaysStoppedAnimation<Color>(cnst.app_primary_material_color),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    getOrderDetail();
  }

  getOrderDetail() async {
    /*try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId},
          {"key": "OrderId", "value": widget.orderId.toString()},
        ];
        print("GetSubCategory Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("GetOrderDetails", formData).then(
                (data) async {
              if (data.length > 0) {
                setState(() {
                  Order = data[0];
                  OrderItems = data[0]["Orderitems"];
                  OrderStatus = data[0]["OrderStatus"];
                  OrderShippingAddress = data[0]["ShippingAddress"];
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Order No ${Order["OrderId"]}",
            style: TextStyle(color: cnst.app_primary_material_color),
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
          elevation: 0,
        ),
        body: Container(
          child: isLoading == false
              ? SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'ITEMS',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: OrderItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OrderedItem(OrderItems[index],widget.status);
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Text(
                    'ORDER STATUS',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  (OrderStatus != null && OrderStatus.length > 0)
                      ? Container(
                    height: double.parse(
                        (90 * OrderStatus.length).toString()),
                    child: Timeline(
                        children: OrderStatus.map((var data) {
                          return TimelineModel(
                            Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${data["Status"]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "${data["Date"].toString().substring(0, 10)}",
                                    ),
                                    Text(
                                      "${data["Notes"]}",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            position: TimelineItemPosition.random,
                            iconBackground: Colors.white,
                            icon: Icon(
                              data["Status"].toString() ==
                                  "Order Placed"
                                  ? Icons.shopping_cart
                                  : (data["Status"].toString() ==
                                  "Order Process"
                                  ? Icons.sync_problem
                                  : (data["Status"]
                                  .toString() ==
                                  "Order Shipped"
                                  ? Icons.local_shipping
                                  : (data["Status"]
                                  .toString() ==
                                  "Order Cancelled"
                                  ? Icons.cancel
                                  : Icons.home))),
                            ),
                          );
                        }).toList(),
                        position: TimelinePosition.Left),
                  )
                      : Container(),
                  /*Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  //color: Colors.grey[300]),
                                  color: Colors.green),
                              child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Text(" ")),
                            ),
                            Container(
                              //color: Colors.grey[300],
                              color: Colors.green,
                              height: 20,
                              width: 2,
                              child: Text(" "),
                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  //color: Colors.grey[300]),
                                  color: Colors.green),
                              child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Text(" ")),
                            ),
                            Container(
                              color: Colors.grey[300],
                              height: 20,
                              width: 2,
                              child: Text(" "),
                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300]),
                              child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Text(" ")),
                            ),
                            Container(
                              color: Colors.grey[300],
                              height: 20,
                              width: 2,
                              child: Text(" "),
                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300]),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 9, bottom: 9),
                                child: Image.asset(
                                  "images/check.png",
                                  height: 25,
                                  width: 25,
                                  fit: BoxFit.fill,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 5),
                              margin: const EdgeInsets.only(bottom: 27),
                              child: Text(
                                "Order Placed",
                                style:
                                TextStyle(color: Colors.green, fontSize: 15),
                              ),
                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 5),
                              margin: const EdgeInsets.only(bottom: 27),
                              child: Text(
                                "Process",
                                style:
                                TextStyle(color: Colors.green, fontSize: 15),
                              ),
                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 5),
                              margin: const EdgeInsets.only(bottom: 27),
                              child: Center(
                                child: Text(
                                  "Shipped",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9, bottom: 9),
                              child: Text(
                                "Delivered",
                                style:
                                TextStyle(color: Colors.black, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),*/
                  Divider(
                    color: Colors.grey,
                  ),
                  Text(
                    'SHIPPING ADDRESS',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${OrderShippingAddress["Name"]}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Text(
                            "${OrderShippingAddress["Address"]}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                        ),
                        Text(
                          "${OrderShippingAddress["Pincode"]}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Text(
                    'PAYMENT DETAIL',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: new Wrap(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Sub Total',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${Order["SubTotal"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Discount',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${Order["Discount"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Shipping Charges',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${Order["DeliveryCharge"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Gift Charges',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${Order["GiftCharge"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'You Save',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${Order["Discount"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Net Paid',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${Order["Total"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(
                        "Payment Mode :  COD",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              : LoadingComponent(),
        ));
  }
}
