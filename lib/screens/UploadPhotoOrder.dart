import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class UploadPhotoOrder extends StatefulWidget {
  @override
  _UploadPhotoOrderState createState() => _UploadPhotoOrderState();
}

class _UploadPhotoOrderState extends State<UploadPhotoOrder> {
  File _orderPhoto;
  TextEditingController txtDescription = new TextEditingController();
  TextEditingController txtAddress = new TextEditingController();
  bool isAddressEdit = false;
  String shippingAddress = "C-123 Pandesara Bamroli Road Surat";
  FlutterAudioRecorder _recorder;
  Recording _recording;
  String hindiDescription = "";
  Duration _duration;
  final translator = new GoogleTranslator();

  //Recording _recordingNew;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  String _alert;
  StreamSubscription _durationSubscription;
  ProgressDialog pr;
  bool _isPlayed = true;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Future _init() async {
    String customPath = '/madhusudan_audio_recorder_';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    //_recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV, sampleRate: 22050);
    _recorder = FlutterAudioRecorder("${customPath}", sampleRate: 22050);
    await _recorder.initialized;
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(
            Icons.settings_voice,
            color: Colors.white,
          );
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop, color: Colors.white);
        }
      case RecordingStatus.Stopped:
        {
          return Icon(Icons.replay, color: Colors.white);
        }
      default:
        return Icon(Icons.do_not_disturb_on, color: Colors.white);
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
      // _recordingNew = result;
    });
  }

  void _play() async {
    print("Path : ${_recording.path}");
    setState(() {
      _isPlayed = false;
    });
    player.play(_recording.path, isLocal: true);
    player.onPlayerCompletion.listen((data) {
      print("Completed");
      setState(() {
        _isPlayed = true;
      });
    });
  }

  void _stop() {
    //AudioPlayer player = AudioPlayer();
    /*print("Path : ${_recording.path}");
    print("Path New : ${_recordingNew.path}");*/
    player.pause();
    setState(() {
      //stop flag
      _isPlayed = true;
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

  order() async {
    if ((txtDescription.text != null && txtDescription.text != "") ||
        (_recording != null && _recording.status == RecordingStatus.Stopped)) {
      try {
        await showPrDialog();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String MemberId = prefs.getString(cnst.session.Member_Id);

        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          String filename = "";
          String imagename = "";
          File compressedFile;

          if (_recording != null) {
            var file = _recording.path.split('/');
            filename = "recording.mp4";

            if (file != null && file.length > 0)
              filename = file[file.length - 1].toString();
          }

          if (_orderPhoto != null) {
            var file = _orderPhoto.path.split('/');
            imagename = "user.png";

            if (file != null && file.length > 0)
              imagename = file[file.length - 1].toString();

            ImageProperties properties =
                await FlutterNativeImage.getImageProperties(_orderPhoto.path);
            compressedFile = await FlutterNativeImage.compressImage(
              _orderPhoto.path,
              quality: 80,
              targetWidth: 600,
              targetHeight:
                  (properties.height * 600 / properties.width).round(),
            );
          }

          FormData formData = new FormData.fromMap({
            "UserId": MemberId,
            "Description": txtDescription.text,
            "HindiComment": hindiDescription,
            "Image": _orderPhoto != null
                ? await MultipartFile.fromFile(compressedFile.path,
                    filename: imagename.toString())
                : null,
            "AudioFile": (_recording != null &&
                    _recording.status == RecordingStatus.Stopped)
                ? await MultipartFile.fromFile(
                    _recording.path,
                    filename: filename,
                  )
                : null
          });
          print("Add To Cart Data =  $formData");
          Services.PostServiceForSave("wl/v1/AddPhotoOrder", formData).then(
              (data) async {
            pr.hide();
            if (data.Data == "1") {
              Navigator.pushNamed(context, '/OrderSuccess');
              showMsg("Order Save Successfully");
              setState(() {
                txtDescription.text = "";
              });
              await _prepare();
            } else {
              showMsg(data.Message);
            }
          }, onError: (e) {
            pr.hide();
            showMsg("Try Again.");
          });
        } else {
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Enter Quantirt");
    }
  }

  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;

    void _opt() async {
      switch (_recording.status) {
        case RecordingStatus.Initialized:
          {
            await _startRecording();
            break;
          }
        case RecordingStatus.Recording:
          {
            await _stopRecording();
            break;
          }
        case RecordingStatus.Stopped:
          {
            await _prepare();
            break;
          }

        default:
          break;
      }

      // 刷新按钮
      setState(() {
        _buttonIcon = _playerIcon(_recording.status);
      });
    }

    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
        onPressed: _opt,
        child: _buttonIcon,
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
      appBar: AppBar(
        title: Text(
          "Photo Order",
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
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  bottom: widt * 0.13, right: 10, left: 10, top: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "UPLOAD ORDER PHOTO",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            var image = await ImagePicker.pickImage(
                              source: ImageSource.camera,
                            );
                            if (image != null) {
                              setState(() {
                                _orderPhoto = image;
                              });
                            }
                          },
                          child: Container(
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(right: 50, top: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(0, 165, 154, .1)),
                            child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                  color: Color.fromRGBO(0, 165, 154, 1),
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setState(() {
                                _orderPhoto = image;
                              });
                            }
                          },
                          child: Container(
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cnst.app_primary_material_color[50]),
                            child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.photo,
                                  size: 25,
                                  color: cnst.app_primary_material_color[900],
                                )),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, bottom: 5),
                      child: Text(
                        'SHIPPING ADDRESS',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        color: Colors.grey[200],
                      ),
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          isAddressEdit == false
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    "${shippingAddress}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                    controller: txtAddress,
                                    autocorrect: true,
                                    scrollPadding: EdgeInsets.all(0),
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      //border: InputBorder.none,
                                      border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: "Enter Something",
                                    ),
                                    //maxLength: 10,
                                    maxLines: 2,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                          isAddressEdit == false
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isAddressEdit = true;
                                      txtAddress.text = shippingAddress;
                                    });
                                  },
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[400]),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: Colors.black,
                                        )),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isAddressEdit = false;
                                      shippingAddress = txtAddress.text;
                                    });
                                  },
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[400]),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.check,
                                          size: 15,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, bottom: 5),
                      child: Text(
                        'DESCRIPTION',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: TextFormField(
                        controller: txtDescription,
                        onEditingComplete: () {
                          if (txtDescription.text != null &&
                              txtDescription.text != "") {
                            translator
                                .translate(txtDescription.text,
                                    from: 'en', to: 'hi')
                                .then((s) {
                              print("Tranlated Text : $s");
                              setState(() {
                                hindiDescription = s;
                              });
                            });
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        autocorrect: true,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                          fillColor: Colors.grey[200],
                          filled: true,
                          //border: InputBorder.none,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter Something",
                        ),
                        //maxLength: 10,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    // Recordeing Start
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, bottom: 5),
                        child: Text(
                          'Or',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: cnst.app_primary_material_color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            child: IconButton(
                              onPressed: _opt,
                              icon: _buttonIcon,
                            ),
                          ),
                          Text(
                            '${_recording != null ? _recording.duration.toString().substring(0, 7) : "-"}',
                          ),
                          _recording?.status == RecordingStatus.Stopped
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: cnst.app_primary_material_color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (_recording != "") {
                                        if (_isPlayed == false) {
                                          _stop();
                                        } else {
                                          _play();
                                        }
                                      }
                                    },
                                    color: Colors.black,
                                    icon: Icon(
                                      _isPlayed == true
                                          ? Icons.play_arrow
                                          : Icons.stop,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    //Recording End

                    _orderPhoto != null
                        ? Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Image.file(
                              File(_orderPhoto.path),
                              //height: 0,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                height: widt * 0.115,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0))),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0.0)),
                  color: cnst.app_primary_material_color[600],
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    order();
                    if (_orderPhoto != null) {
                      if (txtDescription.text != "") {
                        //_addPhotoOrder();
                        print("${txtDescription.text}");
                      } else {
                        Fluttertoast.showToast(
                            msg: "Enter Description.",
                            fontSize: 13,
                            backgroundColor: Colors.redAccent,
                            gravity: ToastGravity.TOP,
                            textColor: Colors.white,);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Select Order Photo",
                          fontSize: 13,
                          backgroundColor: Colors.redAccent,
                          gravity: ToastGravity.TOP,
                          textColor: Colors.white);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                        "ORDER NOW",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: cnst.app_primary_material_color[600],
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
