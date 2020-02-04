import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madhusudan/Common/Constants.dart' as cnst;
import 'package:madhusudan/animation/FadeAnimation.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController edtMobile = new TextEditingController();
  double widt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
    double widt=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
              1, Padding(
                padding: EdgeInsets.only(bottom: widt*0.20,left: widt*0.10,right: widt*0.10),
                child: Image.asset(
                  "images/logo.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        2, TextFormField(
                          controller: edtMobile,
                          cursorColor: Theme.of(context).cursorColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            //fillColor: Colors.white,
                            counterText: "",
                            filled: true,
                            hintText: 'Enter Mobile No',
                            labelText: "Mobile No",
                            prefixIcon: Icon(
                              Icons.phone_iphone,
                              color: Colors.grey,
                            ),
                            //helperText: "password",
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      FadeAnimation(
                        2.5, Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 20),
                          height: 50,
                          decoration: BoxDecoration(

                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                            color: cnst.app_primary_material_color[600],
                            minWidth: MediaQuery.of(context).size.width - 20,
                            onPressed: () {
                              //_checkLogin();
                              //Navigator.pushReplacementNamed(context, '/Dashboard');
                              Navigator.pushReplacementNamed(context, '/Dashboard');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    //shape: BoxShape.circle,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    color: Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.transparent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    //shape: BoxShape.circle,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: cnst.app_primary_material_color,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
