import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.195050, 72.834830),
    zoom: 11.0,
  );

  static final CameraPosition _kLake = CameraPosition(
    target: LatLng(21.195050, 72.834830),
    zoom: 11.0,
  );
  bool isLoading = true;
  ProgressDialog pr;
  List list = new List();

  @override
  void initState() {
    // TODO: implement initState
    _goToTheLake();
    super.initState();
    getContactUs();
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

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
        await showPrDialog();
        pr.show();
        List formData = [];
        setState(() {
          isLoading = true;
        });

        Services.GetServiceForList("wl/v1/GetContactUs", formData).then(
            (data) async {
              pr.hide();
          if (data.length > 0) {
            setState(() {
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
          pr.hide();
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
    var latlong=list[0]["Latlong"].split(',');

    var Lat=double.parse(latlong[0]);
    var Long=double.parse(latlong[1]);
    return <Marker>[
      Marker(
        markerId: MarkerId("${list[0]["Name"]}"),
        draggable: false,
        position: LatLng(Lat, Long),
        infoWindow: InfoWindow(
          title: "${list[0]["Name"]}",
          snippet:
              "${list[0]["Address"].toString()}",
        ),
      ),
    ].toSet();
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
            ? Container()
            : list.length > 0
                ? SingleChildScrollView(
                    child: Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        child: GoogleMap(
                          mapType: MapType.terrain,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: _createMarker(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Name'),
                                subtitle: Text("${list[0]["Name"].toString()}"),
                                enabled: true,
                              ),
                              ListTile(
                                leading: Icon(Icons.phone),
                                title: Text('Mobile'),
                                subtitle: Text("${list[0]["Mobile"].toString()}"),
                              ),
                              ListTile(
                                leading: Icon(Icons.map),
                                title: Text('Address'),
                                subtitle: Text("${list[0]["Address"].toString()}"),
                              ),
                              ListTile(
                                leading: Icon(Icons.map),
                                title: Text('Branch Office'),
                                subtitle: Text("${list[0]["Branch Office"].toString()}"),
                              ),
                              ListTile(
                                leading: Icon(Icons.email),
                                title: Text('Email'),
                                subtitle: Text("${list[0]["Email"].toString()}"),
                              ),
                              ListTile(
                                leading: Icon(Icons.web),
                                title: Text('Website'),
                                subtitle: Text("${list[0]["WebsiteLink"].toString()}"),
                                onTap: (){

                                },
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
