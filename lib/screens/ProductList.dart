import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:madhusudan/animation/FadeAnimation.dart';
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:madhusudan/component/ProductItemCard.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  //CartWishData cartWishData = new CartWishData();
  List searchMemberData = new List();
  bool _isSearching = false, isfirst = false;
  bool isLoading = true;
  List catData = new List();

  @override
  Widget build(BuildContext context) {
    //final myInheritaedWidget = StateContainer.of(context);
    //cartWishData = myInheritaedWidget.cartWishData;

    final double widthScreen = MediaQuery.of(context).size.width;
    final double appBarHeight = kToolbarHeight;
    final double paddingTop = MediaQuery.of(context).padding.top;
    final double paddingBottom = MediaQuery.of(context).padding.bottom;
    final double heightScreen = MediaQuery.of(context).size.height -
        paddingBottom -
        paddingTop -
        appBarHeight;

    return Scaffold(
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text(
                "Product",
                style: TextStyle(color: cnst.app_primary_material_color),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: cnst.app_primary_material_color,
                ),
              ),
              flexibleSpace: new FlexibleSpaceBar(
                background: Column(
                  children: <Widget>[
                    SizedBox(height: 75),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        child: CupertinoTextField(
                          keyboardType: TextInputType.text,
                          placeholder: "Search Product",
                          onChanged: (val) {
                            if (val == "" || val == null) {
                              setState(() {
                                _isSearching = false;
                                isfirst = false;
                                searchMemberData.clear();
                              });
                            } else {
                              searchOperation(val);
                            }
                          },
                          placeholderStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 17.0,
                          ),
                          prefix: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Color(0xffF0F1F5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/MyCart');
                  },
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 15, bottom: 10),
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
            ),
          ];
        },
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            /*child: isLoading == true
                ? LoadingComponent()
                : catData.length > 0 && catData != null
                    ? searchMemberData.length != 0
                        ? GridView.builder(
                            itemCount: searchMemberData.length,
                            //shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width / (430),
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductItemCard(searchMemberData[index]);
                            })
                        : _isSearching && isfirst
                            ? GridView.builder(
                                itemCount: searchMemberData.length,
                                //shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / (430),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductItemCard(
                                      searchMemberData[index]);
                                })
                            : GridView.builder(
                                itemCount: catData.length,
                                //shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / (430),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductItemCard(catData[index]);
                                })
                    : NoDataComponent(),*/

            child: AnimationLimiter(
                child: GridView.builder(
                    //itemCount: searchMemberData.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 50,
                    //shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          MediaQuery.of(context).size.width / (430),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      //return ProductItemCard(searchMemberData[index]);
                      return ProductItemCard(index);
                    })),
          ),
        ),
      ),
    );
  }

  void searchOperation(String searchText) {
    searchMemberData.clear();
    if (_isSearching != null) {
      setState(() {
        _isSearching = true;
        isfirst = true;
      });
      for (int i = 0; i < catData.length; i++) {
        String name = catData[i]["ItemName"];
        //String cmpName = catData[i]["categoryname"];
        if (name.toLowerCase().contains(searchText.toLowerCase())) {
          searchMemberData.add(catData[i]);
        }
      }
    }
    setState(() {});
  }
}
