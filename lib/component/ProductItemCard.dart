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
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetail(Id: widget.ItemData["Id"].toString())));*/

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductDetails()));
      },
      child: AnimationConfiguration.staggeredGrid(
        duration: const Duration(milliseconds: 1000),
        columnCount: 2,
        position: widget.index,
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FlipAnimation(
            child: Card(
              margin: EdgeInsets.only(left: 5, right: 5, top: 8),
              elevation: 3,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                //width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    widget.ItemData["Image"].toString() != "" &&
                            widget.ItemData["Image"].toString() != "null"
                        ? Image.network(
                            "${widget.ItemData["Image"]}",
                            height: 140,
                            width: MediaQuery.of(context).size.width / 2,
                            fit: BoxFit.fill,
                          )
                        : Container(
                            height: 140,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: Text(
                                'No Image Available',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            ),
                          ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        //mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Text(
                              "${widget.ItemData["ItemName"]}",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
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
    );
  }
}
