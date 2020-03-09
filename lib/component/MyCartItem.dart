import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/screens/ProductDetails.dart';
import 'package:madhusudan/utils/AudioProvider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCartItem extends StatefulWidget {
  final int index;
  final dynamic product;
  final Function removeItem;
  final Function updateItemList;

  const MyCartItem(
      {Key key, this.index, this.product, this.removeItem, this.updateItemList})
      : super(key: key);

  @override
  _MyCartItemState createState() => _MyCartItemState();
}

class _MyCartItemState extends State<MyCartItem> {
  AudioPlayer player = AudioPlayer();
  AudioProvider audioProvider;
  bool _isPlayed = true;

  @override
  void initState() {
    // TODO: implement initState
    /*String url = widget.product["AudioFile"];
    audioProvider = new AudioProvider(url);*/
    super.initState();
  }

  void _stop() {
    player.pause();
    setState(() {
      //stop flag
      _isPlayed = true;
    });
  }

  void _play() async {
    audioProvider = new AudioProvider(widget.product["AudioFile"].toString());
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
                        Id: widget.product["ItemId"].toString(),
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
                      child: (widget.product["Image"] != null &&
                              widget.product["Image"] != "")
                          ? Image.network(
                              "${cnst.img_url + widget.product["Image"]}",
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    Id: widget.product["ItemId"].toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              //width: MediaQuery.of(context).size.width / 1.8,
                              //width: widt*0.3,
                              child: Text(
                                "${widget.product["ItemName"]}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            cnst.inr_rupee + " ${widget.product["PcsMrp"]}",
                            style: TextStyle(
                              fontSize: 15,
                              color: cnst.app_primary_material_color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.product["Type"].toString() == "box"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 2, left: 0),
                            child: Text(
                              "( Total Pcs : ${widget.product["Pcs"]}, Rate : ${widget.product["Mrp"]} /piece )",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 2, left: 0),
                            child: Text(
                              "( Minimum Pcs : ${widget.product["MinQty"]} )",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if(widget.product["Type"].toString()=="loose" ){
                                      if(int.parse(widget.product["Qty"].toString())>int.parse(widget.product["MinQty"].toString())){
                                        widget.product["Qty"] = int.parse(widget
                                            .product["Qty"]
                                            .toString()) - 1;
                                        widget.updateItemList(widget.product["Qty"], widget.index);
                                      }
                                    }else{
                                      if (int.parse(widget.product["Qty"].toString()) > 1) {
                                        widget.product["Qty"] = int.parse(widget
                                            .product["Qty"]
                                            .toString()) - 1;
                                        widget.updateItemList(widget.product["Qty"], widget.index);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    /*child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[300]),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "-",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          )),
                                    ),*/
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[300]),
                                      child: Center(
                                        child: Icon(
                                          Icons.remove,
                                          size: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "${widget.product["Qty"]}",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.product["Qty"] = int.parse(
                                            widget.product["Qty"].toString()) +
                                        1;
                                    widget.updateItemList(
                                        widget.product["Qty"], widget.index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                    ),
                                    /*child: Container(
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
                                    ),*/
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[300]),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          widget.product["AudioFile"] != ""
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: cnst.app_primary_material_color,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
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
                    ),
                    widget.product["Comment"] != ""
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(right: 5),
                            child: Text(
                              "${widget.product["Comment"]}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Container()
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
                                  widget.removeItem(widget.index);
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
