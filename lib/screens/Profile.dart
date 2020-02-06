import 'package:flutter/material.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String Name = "", Mobile = "", MemberId = "", MemberImage = "";

  /*String getName() {
    getLocalData();
    return Name;
  }*/

  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 130,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    width: 80,
                    height: 80,
                    child: MemberImage != "" && MemberImage != null
                        ? ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/loading.gif",
                              //image: "${cnst.img_url}${MemberImage}",
                              image: "${MemberImage}",
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              'images/icon_user.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Name",
                        //"${getName()}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Mobile",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              //color: Colors.white,
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/EditProfile');
                      },
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 22,
                                    color: cnst.app_primary_material_color[600],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Edit Profile",
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300]),
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/MyOrder');
                      },
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    "images/myorder.png",
                                    height: 22,
                                    width: 22,
                                    fit: BoxFit.fill,
                                    color: cnst.app_primary_material_color[600],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("My Orders",
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300]),
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.white,
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/AboutUs');
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    "images/info.png",
                                    height: 22,
                                    width: 22,
                                    fit: BoxFit.fill,
                                    color: cnst.app_primary_material_color[600],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("About Us",
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300]),
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/ContactUs');
                      },
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.phone,
                                    size: 22,
                                    color: cnst.app_primary_material_color[600],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Contact Us",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300]),
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    GestureDetector(
                      onTap: () {
                        //rateApp();
                      },
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.star_border,
                                    size: 22,
                                    color: cnst.app_primary_material_color[600],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Rate App",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300]),
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                //color: Colors.white,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.exit_to_app,
                                size: 22,
                                color: cnst.app_primary_material_color[600],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Logout",
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            //width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300]),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
