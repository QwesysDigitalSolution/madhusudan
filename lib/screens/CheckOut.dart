import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:madhusudan/Common/Constants.dart';
import 'package:madhusudan/Common/Services.dart';
import 'package:madhusudan/Component/LoadingComponent.dart';
import 'package:madhusudan/Component/MyCartItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOut extends StatefulWidget {
  List CartItem;

  CheckOut(this.CartItem);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  String selectedType = "personal";
  String MemberId = "0";
  bool isLoading = false;
  List MyCartList = [];
  double subTotal = 0;
  double discount = 0;
  double shippingCharges = 0;
  double giftCharges = 0;
  double youSave = 0;
  double totalAmt = 0;
  double walletAmount = 0.0;
  double walletAmountUsed = 0.0;
  var shippingAddress = {"Name" : "Kapil R Singh","Address":"C-123 Pandesara Bamroli Road Surat","Pincode":"394221"};
  String method = "COD";
  bool isDeleveryAvailable = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      MyCartList = widget.CartItem;
      walletAmount = 0;
    });
    CalculateTotal();
    super.initState();
  }

  getLocalData() async {
   /* SharedPreferences prefs = await SharedPreferences.getInstance();
    String Gender = prefs.getString(Session.Gender);
    setState(() {
      MemberId = prefs.getString(Session.MemberId);
    });*/
  }

  CalculateTotal() async {
    /*setState(() {
      subTotal = 0;
      discount = 0;
      shippingCharges = 0;
      giftCharges = 0;
      youSave = 0;
      totalAmt = 0;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MinDeliveryChargesBalance =
    await prefs.getString(cnst.session.MinDeliveryChargesBalance);
    String DeliveryCharges =
    await prefs.getString(cnst.Session.DeliveryCharges);
    String GiftingCharges = await prefs.getString(cnst.Session.GiftCharges);

    if (MyCartList.length > 0) {
      for (int i = 0; i < MyCartList.length; i++) {
        double AmtDiff = double.parse(MyCartList[i]["Mrp"].toString()) -
            double.parse(MyCartList[i]["SellingPrice"].toString());

        setState(() {
          subTotal += (double.parse(MyCartList[i]["Mrp"].toString()) *
              double.parse(MyCartList[i]["Qty"].toString()));
          discount += AmtDiff * double.parse(MyCartList[i]["Qty"].toString());
          youSave += AmtDiff * double.parse(MyCartList[i]["Qty"].toString());
          totalAmt += (double.parse(MyCartList[i]["SellingPrice"].toString()) *
              double.parse(MyCartList[i]["Qty"].toString()));
        });
      }

      if (double.parse(MinDeliveryChargesBalance.toString()) > totalAmt) {
        setState(() {
          shippingCharges = double.parse(DeliveryCharges);
          totalAmt += double.parse(DeliveryCharges);
        });
      } else {
        setState(() {
          shippingCharges = 0;
        });
      }
      if (selectedType == "gifting") {
        setState(() {
          giftCharges = double.parse(GiftingCharges);
          totalAmt += double.parse(GiftingCharges);
        });
      } else {
        giftCharges = 0;
      }
      if(walletAmount > 0){
        if(walletAmount <= totalAmt){
          setState(() {
            totalAmt -= walletAmount;
            walletAmountUsed = walletAmount;
            youSave += walletAmount;
          });
        }else if(walletAmount > totalAmt){
          setState(() {
            totalAmt -= totalAmt;
            walletAmountUsed = totalAmt;
            youSave += walletAmount;
          });
        }
      }
    } else {
      setState(() {
        totalAmt = 0;
      });
    }*/
  }

  CheckDeleveryAvailability() async {
    /*try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var formData = {
          "Pincode": shippingAddress["Pincode"].toString().trim()
        };
        Services.PostServiceForSave("CheckPincode", formData).then(
                (data) async {
              setState(() {
                isLoading = false;
              });
              if (data.Data != "0" && data.IsSuccess == true) {
                setState(() {
                  isDeleveryAvailable = true;
                });
              } else {
                setState(() {
                  isDeleveryAvailable = false;
                });
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
    }*/
  }

  CheckOut() async {
    /*try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var formData = {
          "SubTotal": subTotal,
          "Discount": discount,
          "Shipping": shippingCharges,
          "GiftCharge": giftCharges,
          "YouSave": youSave,
          "Total": totalAmt,
          "AddressId": shippingAddress["Id"],
          "IsGift": selectedType == "gifting" ? true : false,
          "PaymentMode": "COD",
          "UserId": MemberId,
          "WalletPoint" : walletAmountUsed
        };
        Services.PostServiceForSave("CheckOut", formData).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            Navigator.pushReplacementNamed(context, '/PlaceOrder');
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

  /*CheckAvailablePoint() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String MemberId = prefs.getString(Session.MemberId);
        Future res = Services.GetCurrentAmountInWallet(MemberId);
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.IsSuccess == true) {
            setState(() {
              walletAmount = double.parse(data.Data.toString());
            });
            print("walletAmount : $walletAmount");
          }
          CalculateTotal();
        }, onError: (e) {
          print("Error : on Login Call");
          //showMsg("$e");
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }*/

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
      body: Stack(
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
                        GestureDetector(
                          onTap: () {
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddressList((String action, var data) {
                                      if (action == "Success") {
                                        setState(() {
                                          shippingAddress = data;
                                        });
                                        print("Selected Address" + data.toString());
                                        if (data != null)
                                          CheckDeleveryAvailability();
                                      }
                                    }),
                              ),
                            );*/
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                shippingAddress != null
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${shippingAddress["Name"]}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        "${shippingAddress["Address"]}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                      "${shippingAddress["Pincode"]}",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                )
                                    : Text(
                                  "Select Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddressList((String action, var data) {
                                              if (action == "Success") {
                                                setState(() {
                                                  shippingAddress = data;
                                                });
                                                print("Selected Address" + data.toString());
                                                if (data != null)
                                                  CheckDeleveryAvailability();
                                              }
                                            }),
                                      ),
                                    );*/
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200]),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.edit,
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
                              return MyCartItem(
                                MyCartList[index],
                                ((String action) {
                                  if (action == "ProductRemoved") {
                                    setState(() {
                                      MyCartList.removeAt(index);
                                    });
                                    CalculateTotal();
                                  } else if (action == "QtyChange") {
                                    CalculateTotal();
                                  }
                                }),
                              );
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
                        GestureDetector(
                          onTap: () {
                            var calculation = {
                              "subTotal": subTotal,
                              "discount": discount,
                              "totalAmt": totalAmt
                            };
                            _settingModalBottomSheet(context, calculation);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "TOTAL",
                                style:
                                TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                              Text(
                                cnst.inr_rupee + " ${totalAmt}",
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                              Text(
                                "Click here see full detail.",
                                style:
                                TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        isDeleveryAvailable == true
                            ? Container(
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
                            : Container(),
                      ],
                    ),
                  ),
                ],
              )),
          isLoading == true ? LoadingComponent() : Container()
        ],
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