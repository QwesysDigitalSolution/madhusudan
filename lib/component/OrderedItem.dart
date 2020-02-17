import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/screens/ProductDetails.dart';
import 'package:madhusudan/utils/AudioProvider.dart';

class OrderedItem extends StatefulWidget {
  var product;
  String status;

  OrderedItem(this.product, this.status);

  @override
  _OrderedItemState createState() => _OrderedItemState();
}

class _OrderedItemState extends State<OrderedItem> {
  int quantity = 1;
  AudioPlayer player = AudioPlayer();
  AudioProvider audioProvider;
  bool _isPlayed = true;

  @override
  void initState() {
    // TODO: implement initState
    String url = widget.product["AudioFile"];
    audioProvider = new AudioProvider(url);
    super.initState();
  }

  void _play() async {
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

  void _stop() {
    player.pause();
    setState(() {
      //stop flag
      _isPlayed = true;
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
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //Navigator.pushNamed(context, '/ViewItem');
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
                        borderRadius: BorderRadius.circular(13.0)),
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
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                              /*Id: widget.product["ItemId"].toString(),*/
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: Text(
                        "${widget.product["ItemName"]}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Text(
                    cnst.inr_rupee + " ${int.parse(widget.product["Mrp"])}",
                    style: TextStyle(
                        fontSize: 15, color: cnst.app_primary_material_color),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Quantity : ${widget.product["Qty"]}",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        widget.product["AudioFile"] != ""
                            ? Container(
                                height: 40,
                                width: 40,
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
                                    size: 20,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.product["Comment"] != ""
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.product["Comment"]}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
