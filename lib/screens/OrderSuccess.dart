import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class OrderSuccess extends StatefulWidget {
  @override
  _OrderSuccessState createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/Dashboard',
              (Route<dynamic> route) => false,
            );
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: cnst.app_primary_material_color,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/Dashboard',
            (Route<dynamic> route) => false,
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Image.asset(
                    "images/check.png",
                    height: 65,
                    width: 65,
                    color: cnst.app_primary_material_color,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'OrderPlaced'.tr(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 25, right: 25),
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Successfully'.tr(),
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 25, right: 25),
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'SuccessfullyLine1'.tr(),
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width / 2.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  color: cnst.app_primary_colors[600],
                  //minWidth: MediaQuery.of(context).size.width - 20,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Dashboard',
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'MyOrders'.tr(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: cnst.app_primary_colors[600],
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
