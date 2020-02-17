import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/screens/ProductDetails.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCartItem extends StatelessWidget {
  final int index;
  final dynamic product;
  final Function removeItem;
  final Function updateItemList;

  const MyCartItem(
      {Key key, this.index, this.product, this.removeItem, this.updateItemList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;

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
                        Id: product["ItemId"].toString(),
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
                          (product["Image"] != null && product["Image"] != "")
                              ? Image.network(
                                  "${cnst.img_url + product["Image"]}",
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
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                              Id: product["ItemId"].toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        //width: MediaQuery.of(context).size.width / 1.8,
                        //width: widt*0.3,
                        child: Text(
                          "${product["ItemName"]}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      cnst.inr_rupee + " ${product["Mrp"]}",
                      style: TextStyle(
                        fontSize: 15,
                        color: cnst.app_primary_material_color,
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (int.parse(product["Qty"].toString()) > 1) {
                                    product["Qty"] =
                                        int.parse(product["Qty"].toString()) -
                                            1;
                                    updateItemList(product["Qty"], index);
                                  }
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
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "${product["Qty"]}",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  product["Qty"] =
                                      int.parse(product["Qty"].toString()) + 1;
                                  updateItemList(product["Qty"], index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                  ),
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300]),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  width: 102,
                  height: 35,
                  margin: EdgeInsets.only(
                    right: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                      color: cnst.app_primary_material_color,
                    ),
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text("Delete Conformation"),
                            content: new Text(
                              "Are you sure you want to remove item ?",
                            ),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              new FlatButton(
                                child: new Text("Ok"),
                                onPressed: () {
                                  //removeFromCart();
                                  Navigator.of(context).pop();
                                  removeItem(index);
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
                          Icons.delete,
                          color: cnst.app_primary_material_color,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Text(
                            "Remove",
                            style: TextStyle(
                              color: cnst.app_primary_material_color,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                            ),
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
      ],
    );
  }
}
