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
  var order;
  String status;

  OrderDetail(this.order, this.status);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  ProgressDialog pr;
  bool isLoading = false;

  var Order;
  List OrderItems;
  String shippingAddress = "";

  String TransportName = "";

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
          color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
    );

    print(widget.order.toString());
    setState(() {
      Order = widget.order;
      OrderItems = widget.order["ItemsList"];
    });
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      TransportName = prefs.getString(cnst.session.TransportName);
    });
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
            "Order No ${Order["Id"]}",
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
                              return OrderedItem(
                                OrderItems[index],
                                widget.status,
                              );
                            },
                          ),
                        ),
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
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              "${Order["Address"]}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Text(
                          'Transport Name',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              "${TransportName}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
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
