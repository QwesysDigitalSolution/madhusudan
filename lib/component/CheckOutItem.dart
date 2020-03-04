import 'dart:io';

import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/screens/ProductDetails.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutItem extends StatefulWidget {
  var product1;

  CheckOutItem(this.product1);

  @override
  _CheckOutItemState createState() => _CheckOutItemState();
}

class _CheckOutItemState extends State<CheckOutItem> {
  var Product = {};
  ProgressDialog pr;
  bool isLoading = false;
  double totalAmt = 0;

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
    setState(() {
      Product = widget.product1;
      totalAmt += (double.parse(widget.product1["PcsMrp"].toString()) *
          double.parse(widget.product1["Qty"].toString()));
    });

    print("Product Single Data");
    print(widget.product1);
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
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetails(
                  Id: Product["ItemId"].toString(),
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(right: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child:
                      (Product["Image"] != null && Product["Image"] != "")
                          ? Image.network(
                        "${cnst.img_url + Product["Image"]}",
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
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Text(
                        "${Product["ItemName"]}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      cnst.inr_rupee + " ${totalAmt}",
                      style: TextStyle(fontSize: 15, color: cnst.app_primary_material_color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        isLoading == true ? LoadingComponent() : Container()
      ],
    );
  }
}