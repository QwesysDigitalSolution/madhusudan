import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;

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

  @override
  void initState() {
    // TODO: implement initState
    _goToTheLake();
    super.initState();
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Set<Marker> _createMarker() {
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    return <Marker>[
      Marker(
        markerId: MarkerId("Madhusudan"),
        draggable: false,
        position: LatLng(21.195050, 72.834830),
        infoWindow: InfoWindow(
          title: "Madhusudan",
          snippet:
              '305, Hajoori Chamber, Zampa Bazar,\nSurat, Gujarat - 395003',
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
      body: SingleChildScrollView(
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
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Name'),
                    subtitle: Text('Madhusudan'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Mobile'),
                    subtitle: Text('074057 22940, 097370 01629'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Address'),
                    subtitle: Text(
                        '305, Hajoori Chamber, Zampa Bazar,\nSurat, Gujarat - 395003'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Branch Office (INFINITY)'),
                    subtitle: Text(
                        '305, Hajoori Chamber, Zampa Bazar,\nSurat, Gujarat - 395003'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                    subtitle: Text('demo@gmail.com'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.web),
                    title: Text('Website'),
                    subtitle: Text('http://demo.in'),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
