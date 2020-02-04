import 'package:flutter/material.dart';
import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/NoDataComponent.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  bool isLoading = false;

  showMsg(String msg, {String title = 'Madhusudan'}) {
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
          "Prodect Detail",
          style: TextStyle(color: cnst.app_primary_material_color),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: cnst.app_primary_material_color,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              //Navigator.pushNamed(context, '/MyCart');
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, right: 15, bottom: 10),
                  child: Center(
                      child: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: cnst.app_primary_material_color,
                  )),
                ),
                Container(
                  //width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 4, left: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        //"${cartWishData != null ? cartWishData.CartCount : 0}",
                        "0",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: isLoading == true
            ? LoadingComponent()
            :/* catData.length > 0
                ? */SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*imageList != null && imageList.length > 0
                  ? Container(
                height: height / 2,
                child: Swiper(
                  itemBuilder: (BuildContext, int index) {
                    return new FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image:
                      "${cnst.IMG_URL}${imageList[index]["Image"]}",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context)
                          .size
                          .width /
                          2,
                      height: 200,
                    );
                  },
                  itemCount: imageList.length,
                  itemHeight: 110,
                  pagination: new SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.grey[400],
                      )),
                  control: new SwiperControl(
                      color: cnst.appPrimaryMaterialColor),
                ),
              )*/
                        //  :
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 200,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: Text(
                              'No Image Available',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Text(
                                //"${catData[0]["ItemName"]}",
                                "ItemName",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    inWishlist = !inWishlist;
                                    print(inWishlist);
                                    print(_icon);
                                    inWishlist
                                        ? _icon = Icon(
                                            Icons.favorite_border,
                                            size: 23,
                                            color: Colors.black,
                                          )
                                        : _icon = Icon(
                                            Icons.favorite,
                                            size: 23,
                                            color: Colors.red,
                                          );
                                  });
                                },
                                child: _icon,
                              ),
                            ),*/

                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                  onTap: () {
                                    /* if (catData[0]["InWishList"].toString() ==
                            "true") {
                          removeFromWishlist();
                        } else {
                          addToWishlist();
                        }*/
                                  },
                                  child:
                                      /*catData[0]["InWishList"].toString() ==
                          "true"
                          ? */
                                      Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 23,
                                  )
                                  /* : Icon(
                        Icons.favorite_border,
                        size: 23,
                      ),*/
                                  ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Text(
                            //"${catData[0]["Description"]}",
                            "Description",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15),
                          child: Text(
                            "PRICE",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.only(top: 2, left: 15),
                          child: Text(
                            //cnst.Inr_Rupee + "109.00/-",
                            "${cnst.Inr_Rupee} ${catData[0]["SellingPrice"].toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 15),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              /*catData[0]["Mrp"].toString() !=
                        catData[0]["SellingPrice"].toString()
                        ? */
                              Text(
                                "${cnst.inr_rupee} 100",
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // : Container(),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              Expanded(
                                child: Text(
                                  //"${cnst.inr_rupee} ${catData[0]["SellingPrice"]}",
                                  "${cnst.inr_rupee} 50",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15),
                          child: Text(
                            "QUANTITY",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (quantity != 1) quantity--;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300]),
                                    child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Text(
                                          "-",
                                          style: TextStyle(fontSize: 30),
                                        )),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  quantity.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300]),
                                    child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "+",
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                margin: EdgeInsets.only(top: 20, right: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0)),
                                  color: cnst.app_primary_material_color[600],
                                  minWidth:
                                      MediaQuery.of(context).size.width - 20,
                                  onPressed: () {
                                    //addtoCart('addToCart');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/shoppingcart.png",
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.fill,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 8,
                                            right: 4),
                                        child: Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                margin: EdgeInsets.only(top: 20),
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0)),
                                  color: Color.fromRGBO(0, 165, 154, 1),
                                  minWidth:
                                      MediaQuery.of(context).size.width - 20,
                                  onPressed: () {
                                    //addtoCart('buyNow');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.shopping_basket,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 8,
                                            right: 4),
                                        child: Text(
                                          "Buy Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
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
                  )
                //: NoDataComponent(),
      ),
    );
  }
}
