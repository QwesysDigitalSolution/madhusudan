import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:madhusudan/component/LoadingComponent.dart';

class ImageViewComponent extends StatefulWidget {
  var imageList;

  ImageViewComponent(this.imageList);

  @override
  _ImageViewComponentState createState() => _ImageViewComponentState();
}

class _ImageViewComponentState extends State<ImageViewComponent> {
  PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.imageList["Image"].toString().toLowerCase().contains(".pdf")) {
      setPdf();
    }
    super.initState();
  }

  setPdf() async {
    document = await PDFDocument.fromURL(
        "http://mslive.qwesysdigitalsolutions.in/wp-content/uploads/2020/02/MadhusudanSandhya_compressed.pdf");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.imageList["Image"].toString().toLowerCase().contains(".pdf")
          ? document == null
              ? LoadingComponent()
              : PDFViewer(
                  document: document,
                  showPicker: false,
                )
          : FadeInImage.assetNetwork(
              placeholder: 'images/logo.png',
              image: "${widget.imageList["Image"]}",
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width / 2,
              height: 200,
            ),
    );
  }
}
