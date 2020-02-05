import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/component/LoadingComponent.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String Name = "", Email = "", MemberId = "", MemberImage = "";
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  bool isLoading = false;

  File _memberImage;

  void _profileImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null) {
                        setState(() {
                          _memberImage = image;
                        });
                        //sendUserProfileImg();
                      }
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setState(() {
                          _memberImage = image;
                        });
                        //sendUserProfileImg();
                      }
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(color: cnst.app_primary_material_color),
          ),
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, "");
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 22,
              color: cnst.app_primary_material_color,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading == true
              ? LoadingComponent()
              : SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _profileImagePopup(context);
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 15),
                            width: 115,
                            height: 115,
                            child: ClipOval(
                              child: _memberImage == null
                                  ? MemberImage != "" && MemberImage != null
                                      ? FadeInImage.assetNetwork(
                                          placeholder: "assets/loading.gif",
                                          image: "${MemberImage}",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'images/icon_user.png',
                                          fit: BoxFit.cover,
                                        )
                                  : Image.file(
                                      File(_memberImage.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: edtName,
                                cursorColor: Theme.of(context).cursorColor,
                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  hintText: 'Enter Name',
                                  labelText: "Name",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                  //helperText: "password",
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              TextFormField(
                                controller: edtEmail,
                                cursorColor: Theme.of(context).cursorColor,
                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  hintText: 'Enter Email',
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  //helperText: "password",
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 20),
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
                                    if (edtName.text != "") {
                                      if (edtEmail.text != "") {
                                        if (validateEmail(edtEmail.text) ==
                                            false) {
                                          //_updateMemberInfo();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Enter Valid Email.",
                                              backgroundColor: Colors.red,
                                              gravity: ToastGravity.TOP,
                                              textColor: Colors.white);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Enter Email.",
                                            fontSize: 13,
                                            backgroundColor: Colors.redAccent,
                                            gravity: ToastGravity.TOP,
                                            textColor: Colors.white);
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Enter Name.",
                                          fontSize: 13,
                                          backgroundColor: Colors.redAccent,
                                          gravity: ToastGravity.TOP,
                                          textColor: Colors.white);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          //shape: BoxShape.circle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
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
                                        "Update",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          //shape: BoxShape.circle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color:
                                                cnst.app_primary_material_color[
                                                    600],
                                            size: 15,
                                          ),
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
                  ),
                ),
        ));
  }
}
