import 'dart:io';

import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/screens/ProductDetails.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCartItem extends StatefulWidget {
  var product1;
  Function onChange;

  MyCartItem(this.product1, this.onChange);

  @override
  _MyCartItemState createState() => _MyCartItemState();
}

class _MyCartItemState extends State<MyCartItem> {
  var Product = {};
  ProgressDialog pr;
  bool isLoading = false;

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
    });

    print("Product Single Data");
    print(widget.product1);
  }

  removeFromCart() async {
    /*try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var formData = {"Id": Product["CartId"].toString()};
        print("RemoveCartItem Data = ${formData}");
        setState(() {
          isLoading = true;
        });
        Services.PostServiceForSave("RemoveCartItem", formData).then(
                (data) async {
              setState(() {
                isLoading = false;
              });
              if (data.Data == "1") {
                showMsg("Product Removed Successfully.");
                widget.onChange("ProductRemoved");
              } else {
                showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }*/
  }

  updateCart() async {
    /*try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var formData = {
          "Id": Product["CartId"].toString(),
          "Qty": Product["Qty"].toString()
        };
        print("UpdateCartItem Data = ${formData}");
        setState(() {
          isLoading = true;
        });
        Services.PostServiceForSave("UpdateCartItem", formData).then(
                (data) async {
              setState(() {
                isLoading = false;
              });
              if (data.Data == "1") {
                widget.onChange("QtyChange");
              } else {
                showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
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
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                          /*Id: Product["ItemId"].toString(),*/
                          ),
                    ),
                  );
                },
                child: Container(
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
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/ViewItem');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Text(
                        "${Product["ItemName"]}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  /*Container(
                width: MediaQuery.of(context).size.width / 1.8,
                child: Text(
                  "7, Hot Pink",
                  style: TextStyle(fontSize: 15,color: Colors.black45),
                ),
              ),*/
                  Text(
                    cnst.inr_rupee + " ${Product["SellingPrice"]}",
                    style: TextStyle(fontSize: 15, color: cnst.app_primary_material_color),
                  ),
                  Container(
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (Product["Qty"] != 1) {
                                Product["Qty"] = Product["Qty"] - 1;
                              }
                            });

                            updateCart();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300]),
                              child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text(
                                    "-",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "${Product["Qty"]}",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Product["Qty"] = Product["Qty"] + 1;
                            });

                            updateCart();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300]),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "+",
                                    style: TextStyle(fontSize: 12),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  width: 102,
                  height: 35,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(color: cnst.app_primary_material_color),
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      removeFromCart();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: cnst.app_primary_material_color,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Remove",
                            style: TextStyle(
                                color: cnst.app_primary_material_color,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        isLoading == true ? LoadingComponent() : Container()
      ],
    );
  }
}
