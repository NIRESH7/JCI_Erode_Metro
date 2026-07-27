import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:get/get.dart';

class ImageViewer extends StatelessWidget {
  final _imgLink = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage("${_imgLink[0]}"),
        ),
      ),
    );
  }
}
