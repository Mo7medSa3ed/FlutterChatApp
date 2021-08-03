import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {
  final url;
  ImagePreview({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: PhotoView(
      imageProvider: NetworkImage(url),
    )));
  }
}
