import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/screens/ProductDetails.dart';

class OrderedItem extends StatefulWidget {
  var product;
  String status;

  OrderedItem(this.product, this.status);

  @override
  _OrderedItemState createState() => _OrderedItemState();
}

class _OrderedItemState extends State<OrderedItem> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              //Navigator.pushNamed(context, '/ViewItem');
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
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
                  Navigator.pushNamed(context, '/ViewItem');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: Text(
                    "${widget.product["ItemName"]}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                cnst.inr_rupee + " ${widget.product["Amount"]}",
                style: TextStyle(fontSize: 15, color: cnst.app_primary_material_color),
              ),
              Text(
                "Quantity : ${widget.product["Qty"]}",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
