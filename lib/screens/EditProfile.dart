import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String Name = "", Email = "", MemberId = "", MemberImage = "";
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  bool isLoading = false;

  File _memberImage;

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(cnst.session.Member_Id);
      //Name = prefs.getString(cnst.session.Name);
      MemberImage = prefs.getString(cnst.session.Image);
      txtName.text=prefs.getString(cnst.session.Name);
      txtEmail.text=prefs.getString(cnst.session.Email);
    });
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
                          print(_memberImage);
                        });
                        await showPrDialog();
                        sendUserProfileImg();
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
                        await showPrDialog();
                        sendUserProfileImg();
                      }
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
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

  sendUserProfileImg() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await showPrDialog();
        pr.show();
        String filename = "";
        File compressedFile;

        if (_memberImage != null) {
          var file = _memberImage.path.split('/');
          filename = "user.png";

          if (file != null && file.length > 0)
            filename = file[file.length - 1].toString();

          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(_memberImage.path);
          compressedFile = await FlutterNativeImage.compressImage(
              _memberImage.path,
              quality: 100,
              targetWidth: 600,
              targetHeight:
                  (properties.height * 600 / properties.width).round());
        }

        FormData formData = new FormData.fromMap({
          "UserId": MemberId,
          "Photo": _memberImage != null
              ? await MultipartFile.fromFile(compressedFile.path,
                  filename: filename.toString())
              : null
        });

        Services.PostServiceForSave("wl/v1/UpdateMemberPhoto", formData).then(
            (data) async {
          pr.hide();
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (data.Data != "0" && data.Data != "") {
            await prefs.setString(cnst.session.Image, data.Data);
            showMsg("Profile Updated Successfully.");
          } else {
            showMsg(data.Message);
            setState(() {
              _memberImage = null;
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
          setState(() {
            _memberImage = null;
          });
        });
      }
    } on SocketException catch (_) {
      pr.isShowing() ? pr.hide() : Container();
      showMsg("No Internet Connection.");
    }
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
                                controller: txtName,
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
                                controller: txtEmail,
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
                                    if (txtName.text != "") {
                                      if (txtEmail.text != "") {
                                        if (validateEmail(txtEmail.text) ==
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
