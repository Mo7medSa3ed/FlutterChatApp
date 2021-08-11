import 'package:chat/models/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intel;
import '../../../constants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;
  // color: Theme.of(context).brightness == Brightness.dark
  //     ? Colors.white
  //     : Colors.black,

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message!.isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(message!.isSender ? 1 : 0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message!.text ?? '',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: message!.isSender
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Text(
            intel.DateFormat('h:mm a').format(
                DateTime.parse(message!.createdAt.toString()).toLocal()),
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ),
      ],
    );
  }
}
