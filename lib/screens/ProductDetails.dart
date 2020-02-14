import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:madhusudan/common/ClassList.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/common/Services.dart';
import 'package:madhusudan/common/StateContainer.dart';
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/NoDataComponent.dart';
import 'package:madhusudan/utils/Shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_view/photo_view.dart';
import 'package:madhusudan/utils/DatabaseHelper.dart';
import 'package:translator/translator.dart';

class ProductDetails extends StatefulWidget {
  String Id;

  ProductDetails({this.Id});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController txtDescription = new TextEditingController();
  TextEditingController txtQty = new TextEditingController();
  CartData cartData = new CartData();
  int quantity = 1;
  bool isLoading = true;
  List catData = new List();
  List imageList = new List();
  String MemberId = "0";
  final translator = new GoogleTranslator();
  String hindiDescription = "";

  //Audio File
  FlutterAudioRecorder _recorder;
  Recording _recording;
  AudioPlayer player = AudioPlayer();
  bool _isPlayed = true;
  String _alert;

  //Recording _recordingNew;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      _prepare();
    });
    getItemDetails();
    setState(() {
      txtQty.text = "1";
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
    Directory appDocDirectory;
    if (Platform.isIOS) {
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

  UpdateCartCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({"UserId": MemberId});
        print("getItemDetails Data = ${formData}");
        //pr.show();

        Services.PostServiceForSave("wl/v1/GetCartCount", formData).then(
            (data) async {
          if (data.IsSuccess == true) {
            final myInheritaedWidget = StateContainer.of(context);
            myInheritaedWidget.updateCartData(
              cartCount: int.parse(data.Data.toString()),
            );
            setState(() {
              isLoading = false;
            });
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
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

  getItemDetails() async {
    try {
      await showPrDialog();
      //pr.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberId = prefs.getString(cnst.session.Member_Id);
      setState(() {
        MemberId = memberId;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List formData = [
          {"key": "ItemId", "value": widget.Id.toString()},
          {"key": "UserId", "value": memberId},
        ];
        print("getItemDetails Data = ${formData}");
        //pr.show();
        setState(() {
          isLoading = true;
        });
        Services.GetServiceForList(
                "wl/v1/GetProductDetailByProductId", formData)
            .then((data) async {
          //pr.hide();
          if (data.length > 0) {
            setState(() {
              catData = data;
              imageList = data[0]["Images"];
            });
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      //pr.isShowing() ? pr.hide() : null;
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
    //pr.isShowing() ? pr.hide() : null;
  }

  addToCart() async {
    try {
      await showPrDialog();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.session.Member_Id);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        String filename = "";
        File compressedFile;

        if (_recording != null) {
          var file = _recording.path.split('/');
          filename = "user.png";

          if (file != null && file.length > 0)
            filename = file[file.length - 1].toString();
        }

        FormData formData = new FormData.fromMap({
          "UserId": MemberId,
          "ItemId": widget.Id,
          "Qty": txtQty.text,
          "Comment": txtDescription.text,
          "HindiComment": hindiDescription,
          "AudioFile": (_recording != null &&
                  _recording.status == RecordingStatus.Stopped)
              ? await MultipartFile.fromFile(
                  _recording.path,
                  filename: filename,
                )
              : null
        });
        print("Add To Cart Data =  $formData");
        print("Add To Item Id =  ${widget.Id}");
        Services.PostServiceForSave("wl/v1/AddToCart", formData).then(
            (data) async {
          pr.hide();
          if (data.Data == "1") {
            //Navigator.pushReplacementNamed(context, '/OrderSuccess');
            showMsg("Item Added To Cart Successfully");
            setState(() {
              txtDescription.text = "";
              _recording = null;
              quantity = 1;
            });
            UpdateCartCount();
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
  }

  void _showOverlay(BuildContext context, String id, String image) {
    Future res = databaseHelper.getPhotoOpenCountList(id);
    res.then((data) {
      if (data != null && data.length > 0) {
        print("Image Count : " + data[0].Count);
        if (int.parse(data[0].Count.toString()) < 10) {
          PhotoOpenCountClass photoCount = new PhotoOpenCountClass(
            PhotoId: id,
            MemberId: MemberId,
            Count: "1",
          );
          databaseHelper.updatePhotoOpenCount(photoCount).then((data) {
            print("Update Callback : $data");
            Navigator.of(context).push(ImagePreview(image: image));
          });
        } else {
          showMsg(
            "You have reached to max count to open this image please select other image",
          );
        }
      } else {
        print("Image Count : 0");
        PhotoOpenCountClass photoCount = new PhotoOpenCountClass(
          PhotoId: id,
          MemberId: MemberId,
          Count: "1",
        );
        databaseHelper.insertPhotoOpenCount(photoCount).then((data) {
          print("Insert Callback : $data");
          Navigator.of(context).push(ImagePreview(image: image));
        });
      }
    }, onError: (e) {
      print("Error : " + e.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final myInheritaedWidget = StateContainer.of(context);
    cartData = myInheritaedWidget.cartData;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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

      setState(() {
        _buttonIcon = _playerIcon(_recording.status);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prodect Detail",
          style: TextStyle(color: cnst.app_primary_material_color),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: cnst.app_primary_material_color,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/MyCart');
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, right: 15, bottom: 10),
                  child: Center(
                      child: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: cnst.app_primary_material_color,
                  )),
                ),
                Container(
                  //width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 4, left: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "${cartData != null ? cartData.CartCount : 0}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: isLoading == true
              ? ShimmerProductDetailCardSkeleton(
                  isCircularImage: false,
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (imageList != null && imageList.length > 0)
                        Container(
                          height: height / 2,
                          child: Swiper(
                            itemBuilder: (BuildContext, int index) {
                              return GestureDetector(
                                onTap: () {
                                  _showOverlay(
                                      context,
                                      imageList[index]["Id"].toString(),
                                      imageList[index]["Image"]);
                                },
                                child: new FadeInImage.assetNetwork(
                                  placeholder: 'assets/loading.gif',
                                  image: "${imageList[index]["Image"]}",
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 200,
                                ),
                              );
                            },
                            itemCount: imageList.length,
                            itemHeight: 110,
                            pagination: new SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                              color: Colors.grey[400],
                            )),
                            control: new SwiperControl(
                                color: cnst.app_primary_material_color),
                          ),
                        )
                      else
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 200,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: Text(
                              'No Image Available',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Text(
                          "${catData[0]["ItemName"]}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Text(
                          "${catData[0]["Description"]}",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15),
                        child: Text(
                          "PRICE",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 15),
                        child: Text(
                          "${cnst.inr_rupee} ${catData[0]["Mrp"]}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15),
                        child: Text(
                          "QUANTITY",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: new IconButton(
                                icon: new Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  int qty =
                                      txtQty.text != null && txtQty.text != ""
                                          ? int.parse(txtQty.text)
                                          : 0;
                                  if (qty != 1 && qty != 0) {
                                    qty--;
                                    setState(() {
                                      txtQty.text = qty.toString();
                                    });
                                  } else {
                                    setState(() {
                                      txtQty.text = "1";
                                    });
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: 80,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: txtQty,
                                cursorColor: Theme.of(context).cursorColor,
                                decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  counterText: "",
                                  filled: true,
                                ),
                                maxLength: 5,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: new IconButton(
                                icon: new Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  int qty =
                                      txtQty.text != null && txtQty.text != ""
                                          ? int.parse(txtQty.text)
                                          : 0;
                                  qty++;
                                  setState(() {
                                    txtQty.text = qty.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: new Wrap(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: TextFormField(
                                controller: txtDescription,
                                onEditingComplete: () {
                                  translator
                                      .translate(txtDescription.text,
                                          from: 'en', to: 'hi')
                                      .then((s) {
                                    print("Tranlated Text : $s");
                                    setState(() {
                                      hindiDescription = s;
                                    });
                                  });
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
                                    hintText: "Enter Something"),
                                //maxLength: 10,
                                maxLines: 4,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Center(
                              child: Text("OR"),
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
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: cnst.app_primary_material_color,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
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
                                            color:
                                                cnst.app_primary_material_color,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
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
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 20,
                              margin: EdgeInsets.only(top: 20, right: 10),
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
                                  addToCart();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/shoppingcart.png",
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.fill,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8, left: 8, right: 4),
                                      child: Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 20,
                              margin: EdgeInsets.only(top: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0)),
                                color: Color.fromRGBO(0, 165, 154, 1),
                                minWidth:
                                    MediaQuery.of(context).size.width - 20,
                                onPressed: () {
                                  //addtoCart('buyNow');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.shopping_basket,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8, left: 8, right: 4),
                                      child: Text(
                                        "Buy Now",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
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
                )
          //: NoDataComponent(),
          ),
    );
  }
}

class ImagePreview extends ModalRoute<void> {
  String image;

  ImagePreview({this.image});

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    print('image URl : ' + image);
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: "Sliderimage",
            child: PhotoView(
              imageProvider: NetworkImage(image),
            ),
          ),
        ),
        Positioned(
          //width: MediaQuery.of(context).size.width,
          right: 10,
          child: IconButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
