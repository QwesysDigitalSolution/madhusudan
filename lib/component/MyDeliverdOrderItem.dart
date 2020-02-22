import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Constants.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/screens/OrderDetail.dart';
import 'package:madhusudan/utils/AudioProvider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDeliverdOrderItem extends StatefulWidget {
  var order;

  MyDeliverdOrderItem(this.order);

  @override
  _MyDeliverdOrderItemState createState() => _MyDeliverdOrderItemState();
}

class _MyDeliverdOrderItemState extends State<MyDeliverdOrderItem> {
  List productList;
  AudioPlayer player = AudioPlayer();
  AudioProvider audioProvider;
  bool _isPlayed = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      productList = widget.order["ItemsList"];
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

  void _stop() {
    player.pause();
    setState(() {
      //stop flag
      _isPlayed = true;
    });
  }

  void _play() async {
    audioProvider = new AudioProvider(productList[0]["AudioFile"].toString());
    String localUrl = await audioProvider.load();
    player.play(localUrl, isLocal: true).then((data) {
      print("Path : $localUrl");
      setState(() {
        _isPlayed = false;
      });
    });

    player.onPlayerCompletion.listen((data) {
      print("Completed");
      setState(() {
        _isPlayed = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetail(
              widget.order,
              "pending",
            ),
          ),
        );*/
      },
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Order No ${productList[0]["OrderId"]}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 0, right: 5),
                      child: Text(
                        "${widget.order["Date"].toString().substring(0, 10)}",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(right: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: (productList[0]["Image"] != null &&
                                productList[0]["Image"] != "")
                            ? ClipRRect(
                                borderRadius: new BorderRadius.circular(10.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/loading.gif",
                                  image:
                                      "${cnst.img_url + productList[0]["Image"]}",
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.fill,
                                ),
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
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        productList[0]["Comment"] != ""
                            ? Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 5),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(right: 5),
                                    child: Text(
                                      "${productList[0]["Comment"]}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        productList[0]["AudioFile"] != ""
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: cnst.app_primary_material_color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (_isPlayed == false) {
                                        _stop();
                                      } else {
                                        _play();
                                      }
                                    },
                                    color: Colors.black,
                                    icon: Icon(
                                      _isPlayed == true
                                          ? Icons.play_arrow
                                          : Icons.stop,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
