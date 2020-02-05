import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/component/MyCartItem.dart';
import 'package:madhusudan/screens/CheckOut.dart';
/*import 'package:madhusudan/screens/StateContainer.dart';*/
import 'package:shared_preferences/shared_preferences.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final List<String> title = ["Face", "Eyes", "Lips", "Nails"];
  String MemberId = "0";
  bool isLoading = false;
  List CartList = [
    {
      "ItemId": 1,
      "CartId": 2,
      "Qty": 1,
      "ItemCode": "10001",
      "ItemName": "Olay Total Effects 7 In One Touch Of Foundation",
      "Mrp": 849.00,
      "SellingPrice": 807.00,
      "Discount": 0.0,
      "DiscountPer": 0.0,
      "Description": "Olay Total Effects 7 In One Touch Of Foundation : 2020-02-01",
      "Image": "https://5.imimg.com/data5/XS/GB/MY-22453630/self-design-pure-silk-pink-saree-500x500.jpg"
    },
    {
      "ItemId": 1,
      "CartId": 2,
      "Qty": 1,
      "ItemCode": "10001",
      "ItemName": "Olay Total Effects 7 In One Touch Of Foundation",
      "Mrp": 849.00,
      "SellingPrice": 807.00,
      "Discount": 0.0,
      "DiscountPer": 0.0,
      "Description": "Olay Total Effects 7 In One Touch Of Foundation : 2020-02-01",
      "Image": "https://images-na.ssl-images-amazon.com/images/I/71kK5wShumL._UY550_.jpg"
    },
    {
      "ItemId": 1,
      "CartId": 2,
      "Qty": 1,
      "ItemCode": "10001",
      "ItemName": "Olay Total Effects 7 In One Touch Of Foundation",
      "Mrp": 849.00,
      "SellingPrice": 807.00,
      "Discount": 0.0,
      "DiscountPer": 0.0,
      "Description": "Olay Total Effects 7 In One Touch Of Foundation : 2020-02-01",
      "Image": "https://images-na.ssl-images-amazon.com/images/I/91NXYyxk9LL._UL1500_.jpg"
    },
    {
      "ItemId": 1,
      "CartId": 2,
      "Qty": 1,
      "ItemCode": "10001",
      "ItemName": "Olay Total Effects 7 In One Touch Of Foundation",
      "Mrp": 849.00,
      "SellingPrice": 807.00,
      "Discount": 0.0,
      "DiscountPer": 0.0,
      "Description": "Olay Total Effects 7 In One Touch Of Foundation : 2020-02-01",
      "Image": "https://n2.sdlcdn.com/imgs/i/2/e/offline-selection-Red-Pink-Blue-SDL908906437-1-28686.jpeg"
    },
    {
      "ItemId": 1,
      "CartId": 2,
      "Qty": 1,
      "ItemCode": "10001",
      "ItemName": "Olay Total Effects 7 In One Touch Of Foundation",
      "Mrp": 849.00,
      "SellingPrice": 807.00,
      "Discount": 0.0,
      "DiscountPer": 0.0,
      "Description": "Olay Total Effects 7 In One Touch Of Foundation : 2020-02-01",
      "Image": "https://n1.sdlcdn.com/imgs/g/n/6/Onlinefayda-Pink-Silk-Saree-SDL091337954-1-db58e.jpg"
    },
    {
      "ItemId": 1,
      "CartId": 2,
      "Qty": 1,
      "ItemCode": "10001",
      "ItemName": "Olay Total Effects 7 In One Touch Of Foundation",
      "Mrp": 849.00,
      "SellingPrice": 807.00,
      "Discount": 0.0,
      "DiscountPer": 0.0,
      "Description": "Olay Total Effects 7 In One Touch Of Foundation : 2020-02-01",
      "Image": "https://img6.craftsvilla.com/image/upload/w_500/C/V/CV-35646-MCRAF78906166300-1543305436-Craftsvilla_1.jpg"
    }
  ];
  double subTotal = 0;
  double discount = 0;
  double shippingCharges = 0;
  double giftCharges = 0;
  double youSave = 0;
  double totalAmt = 0;
  double walletAmount = 0;
  double walletAmountUsed = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
    CheckAvailablePoint();
  }

  getLocalData() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    String Gender = prefs.getString(cnst.session.Gender);
    setState(() {
      MemberId = prefs.getString(Session.MemberId);
    });

    getOrderDetail();*/
  }

  CheckAvailablePoint() async {
    /*try {
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
    }*/
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
    /*try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId}
        ];
        print("GetMyCart Data = ${formData}");
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("GetMyCart", formData).then((data) async {
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
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }*/
  }

  CalculateTotal() async{
    /*setState(() {
      subTotal = 0;
      discount = 0;
      shippingCharges = 0;
      giftCharges = 0;
      youSave = 0;
      totalAmt = 0;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MinDeliveryChargesBalance = await prefs.getString(cnst.Session.MinDeliveryChargesBalance);
    String DeliveryCharges = await prefs.getString(cnst.Session.DeliveryCharges);

    if (CartList.length > 0) {
      for (int i = 0; i < CartList.length; i++) {
        double AmtDiff = double.parse(CartList[i]["Mrp"].toString()) -
            double.parse(CartList[i]["SellingPrice"].toString());

        setState(() {
          subTotal += (double.parse(CartList[i]["Mrp"].toString()) *
              double.parse(CartList[i]["Qty"].toString()));
          discount += AmtDiff * double.parse(CartList[i]["Qty"].toString());
          youSave += AmtDiff * double.parse(CartList[i]["Qty"].toString());
          totalAmt += (double.parse(CartList[i]["SellingPrice"].toString()) *
              double.parse(CartList[i]["Qty"].toString()));
        });
      }

      if(double.parse(MinDeliveryChargesBalance.toString()) > totalAmt){
        setState(() {
          shippingCharges = double.parse(DeliveryCharges);
          totalAmt += double.parse(DeliveryCharges);
        });
      }else{
        setState(() {
          shippingCharges = 0;
        });
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

  UpdateCartWishCount() async {
    /*try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "UserId", "value": MemberId},
        ];
        print("getItemDetails Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("WishListCartCounter", formData).then(
                (data) async {
              if (data.length > 0) {
                final myInheritaedWidget = StateContainer.of(context);
                myInheritaedWidget.updateCartWishData(
                  cartCount: data[0]["cartcounter"],
                  wishCount: data[0]["wishcounter"],
                );
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
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 186,
            margin: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: CartList.length,
              itemBuilder: (BuildContext context, int index) {
                return MyCartItem(
                  CartList[index],
                  ((String action) {
                    if (action == "ProductRemoved") {
                      setState(() {
                        CartList.removeAt(index);
                      });
                      CalculateTotal();
                      UpdateCartWishCount();
                    } else if (action == "QtyChange") {
                      CalculateTotal();
                    }
                  }),
                );
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
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        cnst.inr_rupee + " ${totalAmt}",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      Text(
                        "Click here see full detail.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 165,
                  //margin: EdgeInsets.only(top: 20),
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: cnst.app_primary_material_color[600],
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
              /*Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Shipping Charges',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${calculation["shippingCharges"]}",
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
                      'Gift Charges',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${calculation["giftCharges"]}",
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
                      'Wallet Point Used',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${calculation["walletAmountUsed"]}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),*/
              /*Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'You Save',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${calculation["youSave"]}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),*/
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