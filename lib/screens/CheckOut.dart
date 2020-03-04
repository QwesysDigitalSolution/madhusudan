import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/common/StateContainer.dart';
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/CheckOutItem.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOut extends StatefulWidget {
  List CartItem;

  CheckOut(this.CartItem);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  TextEditingController txtAddress = new TextEditingController();

  String selectedType = "personal";
  String MemberId = "0";
  bool isLoading = false;
  List MyCartList = [];
  double totalAmt = 0;
  String shippingAddress = "";
  String method = "COD";
  bool isAddressEdit = false;
  ProgressDialog pr;
  double totalPcs = 0;

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
        color: Colors.black,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
    );
    // TODO: implement initState
    setState(() {
      MyCartList = widget.CartItem;
    });
    CalculateTotal();
    getLocalData();
    super.initState();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
      shippingAddress = prefs.getString(cnst.session.Address);
    });
  }

  CalculateTotal() async {
    setState(() {
      totalAmt = 0;
    });
    print("CalculateTotal");
    if (MyCartList.length > 0) {
      for (int i = 0; i < MyCartList.length; i++) {
        setState(() {
          totalAmt += (double.parse(MyCartList[i]["PcsMrp"].toString()) *
              double.parse(MyCartList[i]["Qty"].toString()));
        });
      }
    } else {
      setState(() {
        totalAmt = 0;
      });
    }
  }

  CheckOut() async {
    if ((shippingAddress == null || shippingAddress == "") &&
        txtAddress.text != "") {
      setState(() {
        shippingAddress = txtAddress.text;
      });
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        FormData formData = new FormData.fromMap(
            {"UserId": MemberId, "Address": shippingAddress});

        Services.PostServiceForSave("wl/v1/CheckOut", formData).then(
                (data) async {
              setState(() {
                isLoading = false;
              });
              if (data.Data != "0" && data.IsSuccess == true) {
                UpdateCartCount();
                Navigator.pushNamed(context, '/OrderSuccess');
              } else {
                showMsg(data.Message);
              }
            }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }

    /*if (shippingAddress != null && shippingAddress != "") {
    } else {
      showMsg("Please Enter Address !");
    }*/
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
        setState(() {
          isLoading = true;
        });
        Services.PostServiceForSave("wl/v1/GetCartCount", formData).then(
            (data) async {
          if (data.IsSuccess == true) {
            final myInheritaedWidget = StateContainer.of(context);
            myInheritaedWidget.updateCartData(
              cartCount: int.parse(data.Data.toString()),
            );
            setState(() {
              isLoading = false;
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out",
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 175,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              'SHIPPING ADDRESS',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(8.0),
                                color: Colors.grey[200],
                              ),
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  isAddressEdit == false
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: Text(
                                            "${shippingAddress}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: TextFormField(
                                            controller: txtAddress,
                                            onEditingComplete: () {
                                              shippingAddress = txtAddress.text;
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                            autocorrect: true,
                                            scrollPadding: EdgeInsets.all(0),
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                              //border: InputBorder.none,
                                              border: new OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: "Enter Something",
                                            ),
                                            //maxLength: 10,
                                            maxLines: 2,
                                            keyboardType: TextInputType.text,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                  isAddressEdit == false
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAddressEdit = true;
                                              txtAddress.text = shippingAddress;
                                            });
                                          },
                                          child: Container(
                                            //width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(right: 15),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[400]),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 15,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAddressEdit = false;
                                              shippingAddress = txtAddress.text;
                                            });
                                          },
                                          child: Container(
                                            //width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(right: 15),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[400]),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 15,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              'ITEMS',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: MyCartList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckOutItem(MyCartList[index]);
                              },
                            ),
                          ),
                          /*Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Add Promo Code',
                            style: TextStyle(
                                color: cnst.app_primary_material_color,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                          Container(
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200]),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ),*/
                        ],
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
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
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
                              color: cnst.app_primary_colors[600],
                              //minWidth: MediaQuery.of(context).size.width - 20,
                              onPressed: () {
                                CheckOut();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "PLACE ORDER",
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
                                        color: cnst.app_primary_colors[600],
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            isLoading == true ? LoadingComponent() : Container()
          ],
        ),
      ),
    );
  }
}

void _settingModalBottomSheet(context, var calculation) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Sub Total',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${calculation["subTotal"]}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Discount',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${calculation["discount"]}",
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
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Net Payable',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${calculation["totalAmt"]}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
