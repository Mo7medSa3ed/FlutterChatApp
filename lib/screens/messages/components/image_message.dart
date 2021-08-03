import 'package:chat/constants.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/screens/messages/components/image_preview.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final ChatMessage? message;
  ImageMessage({this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goTo(
          context,
          ImagePreview(
            url: message!.attachLink!,
          )),
      child: Container(
        height: 240,
        width: 200,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: NetworkImage(message!.attachLink!))),
      ),
    );
  }
}
