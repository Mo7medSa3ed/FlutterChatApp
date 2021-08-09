import 'package:chat/constants.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/screens/messages/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: message!.isSender
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Container(
            height: 240,
            width: 200,
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(20),
                image:
                    DecorationImage(image: NetworkImage(message!.attachLink!))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Text(
              DateFormat('h:mm a')
                  .format(DateTime.parse(message!.createdAt.toString())),
              style: TextStyle(
                fontSize: 10,
                color: message!.isSender
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
