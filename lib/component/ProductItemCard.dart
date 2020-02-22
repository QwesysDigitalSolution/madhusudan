import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/screens/ProductDetails.dart';

class ProductItemCard extends StatefulWidget {
  var ItemData;
  int index;

  ProductItemCard(this.ItemData, this.index);

  @override
  _ProductItemCardState createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetails(Id: widget.ItemData["Id"].toString())));
      },
      child: AnimationConfiguration.staggeredGrid(
        duration: const Duration(milliseconds: 1000),
        columnCount: 2,
        position: widget.index,
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FlipAnimation(
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                //side: BorderSide(color: cnst.appcolor)),
                side: BorderSide(width: 0.10, color: Colors.transparent),
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: Container(
                //width: MediaQuery.of(context).size.width / 2,
                //width: 170,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      widget.ItemData["Image"].toString() != "" &&
                              widget.ItemData["Image"].toString() != "null"
                          ? /*Image.network(
                              "${widget.ItemData["Image"]}",
                              //height: 140,
                              //width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.cover,
                            )*/
                          FadeInImage.assetNetwork(
                              placeholder: "assets/loading.gif",
                              image: "${widget.ItemData["Image"]}",
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 140,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: Text(
                                  'No Image Available',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                              ),
                            ),
                      Container(
                        //width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        color: Colors.white,
                        child: Row(
                          //mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 0),
                                child: Text(
                                  "${widget.ItemData["ItemName"]}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 3, bottom: 5),
                              child: Text(
                                "${cnst.inr_rupee} ${widget.ItemData["Mrp"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
