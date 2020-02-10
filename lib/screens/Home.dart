import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/screens/ProductList.dart';
import 'package:madhusudan/utils/Shimmer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: widt * 0.05,
                left: widt * 0.20,
                right: widt * 0.20,
              ),
              child: Image.asset(
                "images/logo.png",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, '/ProductList');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductList(
                            "Box"
                          ),
                        ),
                      );
                    },
                    child: Container(
                      //margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      width: widt * 0.44,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "images/box.png",
                            height: 150,
                          ),
                          Text(
                            "Box",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, '/ProductList');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductList(
                              "Loose"
                          ),
                        ),
                      );
                    },
                    child: Container(
                      //margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      width: widt * 0.44,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "images/sareeicon.jpg",
                            height: 150,
                          ),
                          Text(
                            "Loose",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/UploadPhotoOrder');
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Upload Order Photo",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Image.asset("images/camera.png"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
