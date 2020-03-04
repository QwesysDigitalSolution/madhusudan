import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:madhusudan/utils/Shimmer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  Completer<GoogleMapController> _controller = Completer();
  var LATI, LONG;
  bool isLoading = true;
  ProgressDialog pr;
  List list = new List();

  @override
  void initState() {
    // TODO: implement initState
    //_goToTheLake();
    super.initState();
    getContactUs();
  }

  /*Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/

  showPrDialog() async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                cnst.app_primary_material_color),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.app_primary_material_color),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getContactUs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [];
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList("wl/v1/GetContactUs", formData).then(
            (data) async {
          if (data.length > 0) {
            var latlong = data[0]["Latlong"].split(',');
            setState(() {
              LATI = double.parse(latlong[0]);
              LONG = double.parse(latlong[1]);
              list = data;
              isLoading = false;
            });
            //await setData(data);
          } else {
            //pr.hide();
            setState(() {
              list.clear();
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            list.clear();
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        list.clear();
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  Set<Marker> _createMarker() {
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    if (list[0]["Latlong"].toString() != "") {
      /*var latlong=list[0]["Latlong"].split(',');
    var Lat=double.parse(latlong[0]);
    var Long=double.parse(latlong[1]);*/
      return <Marker>[
        Marker(
          markerId: MarkerId("${list[0]["Name"]}"),
          draggable: false,
          position: LatLng(LATI, LONG),
          infoWindow: InfoWindow(
            title: "${list[0]["Name"]}",
            snippet: "${list[0]["Address"].toString()}",
          ),
        ),
      ].toSet();
    }
  }
  _launchURL(String no) async {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$no");
    launch(urlwithmobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Us",
          style: TextStyle(color: cnst.app_primary_material_color),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: cnst.app_primary_material_color,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? ShimmerProductDetailCardSkeleton(
                isCircularImage: false,
              )
            : list.length > 0
                ? SingleChildScrollView(
                    child: Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        child: LATI != "" && LONG != ""
                            ? GoogleMap(
                                mapType: MapType.terrain,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(LATI, LONG),
                                  zoom: 11.0,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                markers: _createMarker(),
                              )
                            : Center(
                                child: Text("Location Not Available"),
                              ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.person,
                                        color: cnst.app_primary_material_color,
                                      ),
                                      title: Text('Name'),
                                      subtitle: Text("${list[0]["Name"].toString()}"),
                                      enabled: true,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      //url lunched
                                      _launchURL("8758422007");
                                      /*if(list[0]["WhatsappNo"].toString()!=""){
                                        _launchURL(list[0]["WhatsappNo"].toString());
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: "Mobile Number Not Available",
                                            fontSize: 13,
                                            backgroundColor: Colors.redAccent,
                                            gravity: ToastGravity.CENTER,
                                            textColor: Colors.white);
                                      }*/
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5),
                                      child: Image.asset("images/whatsapp.png",height: 30,width: 30,),
                                    ),
                                  )
                                ],
                              ),
                              ListTile(
                                leading: Icon(Icons.phone,
                                    color: cnst.app_primary_material_color),
                                title: Text('Mobile'),
                                subtitle:
                                    Text("${list[0]["Mobile"].toString()}"),
                              ),
                              ListTile(
                                leading: Icon(Icons.map,
                                    color: cnst.app_primary_material_color),
                                title: Text('Address'),
                                subtitle:
                                    Text("${list[0]["Address"].toString()}"),
                              ),
                              /*ListTile(
                                leading: Icon(Icons.map),
                                title: Text('Branch Office'),
                                subtitle: Text(
                                    "${list[0]["Branch Office"].toString()}"),
                              ),*/
                              ListTile(
                                leading: Icon(Icons.account_balance,
                                    color: cnst.app_primary_material_color),
                                title: Text('Account Details'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(list[0]["GSTNo"].toString() !=
                                        "" &&
                                        list[0]["GSTNo"] != null
                                        ? "GSTNo : ${list[0]["GSTNo"]}"
                                        : "GSTNo :  - "),
                                    Text(list[0]["AccountNumber"].toString() !=
                                                "" &&
                                            list[0]["AccountNumber"] != null
                                        ? "Account Number : ${list[0]["AccountNumber"]}"
                                        : "Account Number :  - "),
                                    Text(list[0]["IFSCCode"].toString() !=
                                        "" &&
                                        list[0]["IFSCCode"] != null
                                        ? "IFSC Code : ${list[0]["IFSCCode"]}"
                                        : "IFSC Code :  - "),

                                    Text(list[0]["HolderName"].toString() !=
                                        "" &&
                                        list[0]["HolderName"] != null
                                        ? "Holder Name : ${list[0]["HolderName"]}"
                                        : "Holder Name :  - "),

                                  ],
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.email,
                                    color: cnst.app_primary_material_color),
                                title: Text('Email'),
                                subtitle:
                                    Text("${list[0]["Email"].toString()}"),
                              ),
                              ListTile(
                                leading: Icon(Icons.perm_contact_calendar,
                                    color: cnst.app_primary_material_color),
                                title: Text('Salesman Box Contact'),
                                subtitle:
                                Text(list[0]["SalesmanBox"].toString() !=
                                    "" &&
                                    list[0]["SalesmanBox"] != null
                                    ? "${list[0]["SalesmanBox"]}"
                                    : " - "),
                              ),
                              ListTile(
                                leading: Icon(Icons.perm_contact_calendar,
                                    color: cnst.app_primary_material_color),
                                title: Text('Salesman Loose Contact'),
                                subtitle:
                                Text(list[0]["Salesmanloose"].toString() !=
                                    "" &&
                                    list[0]["Salesmanloose"] != null
                                    ? "${list[0]["Salesmanloose"]}"
                                    : " - "),
                              ),
                              ListTile(
                                leading: Icon(Icons.web,
                                    color: cnst.app_primary_material_color),
                                title: Text('Website'),
                                subtitle: Text(
                                    "${list[0]["WebsiteLink"].toString()}"),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
                : NoDataComponent(),
      ),
    );
  }
}
