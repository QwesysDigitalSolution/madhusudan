import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String Name = "", Mobile = "", MemberId = "", MemberImage = "";
  String appPackage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
    setPack();
  }

  String getName() {
    getLocalData();
    return Name;
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
      Name = prefs.getString(cnst.session.Name);
      Mobile = prefs.getString(cnst.session.Mobile);
      MemberImage = prefs.getString(cnst.session.Image);
    });
  }

  setPack() async {
    try {
      appPackage = await GetVersion.appID;
    } on PlatformException {
      appPackage = 'Failed to get project version.';
    }
    setState(() {
      appPackage = appPackage;
    });
  }

  rateApp() async {
    String url = 'https://play.google.com/store/apps/details?id=${appPackage}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, "/login");
  }

  //app language dialog
  showSucDialog(String PaymentIs) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          var data = EasyLocalizationProvider.of(context).data;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
            ), //this right here
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: cnst.app_primary_material_color,
                    ),
                    child: Center(
                        child: Text(
                      "Select Language",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 0.5),
                    )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  GestureDetector(
                    onTap: () {
                      data.changeLocale(locale: Locale("en", "US"));
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      //color: Colors.deepOrange,
                      child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                          child: Center(child: Text("English"))),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  GestureDetector(
                    onTap: () {
                      data.changeLocale(locale: Locale("hi", "IN"));
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      //color: Colors.deepOrange,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                          child: Center(child: Text("Hindi"))),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 10)),
                  GestureDetector(
                    onTap: () {
                      data.changeLocale(locale: Locale("gu", "IN"));
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      //color: Colors.deepOrange,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                          child: Center(child: Text("Gujarati"))),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 10)),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

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
                        "${getName()}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${Mobile}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
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
                                  child: Text('EditProfile'.tr(),
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
                                  child: Text('MyOrders'.tr(),
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
                                  child: Text('AboutUs'.tr(),
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
                                    'ContactUs'.tr(),
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
                        rateApp();
                        //https://play.google.com/store/search?q=whatsapp&hl=en
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
                                  child: Text('RateApp'.tr(),
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
                    Divider(
                      color: Colors.grey[300],
                    ),
                    GestureDetector(
                      onTap: () {
                        showSucDialog("asfdsaa");
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
                                    "images/language.png",
                                    width: 25,
                                    height: 25,
                                    color: cnst.app_primary_material_color[600],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('AppLanguage'.tr(),
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
                _logout();
                //Navigator.pushReplacementNamed(context, '/login');
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
                              child: Text('Logout'.tr(),
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
