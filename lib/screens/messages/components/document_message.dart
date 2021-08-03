import 'package:chat/constants.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:flutter/material.dart';

class DocumentMessage extends StatefulWidget {
  final ChatMessage? message;
  DocumentMessage({this.message});
  @override
  _DocumentMessageState createState() => _DocumentMessageState();
}

class _DocumentMessageState extends State<DocumentMessage> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.file_copy),
            SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text("App not support documents",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).textTheme.bodyText1!.color!)),
            )
          ],
        ),
      ),
    );
  }
}
