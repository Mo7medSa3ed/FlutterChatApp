import 'package:chat/api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChatInputField extends StatefulWidget {
  final roomId;
  final senderToId;
  ChatInputField({
    Key? key,
    this.roomId,
    this.senderToId,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final textController = TextEditingController(text: '');

  @override
  void initState() {
    textController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            //Icon(Icons.mic, color: kPrimaryColor),
            //SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),

                    SizedBox(width: kDefaultPadding),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // Icon(
                    //   Icons.attach_file,
                    //   color: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1!
                    //       .color!
                    //       .withOpacity(0.64),
                    // ),
                    // SizedBox(width: kDefaultPadding / 4),
                    // Icon(
                    //   Icons.camera_alt_outlined,
                    //   color: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1!
                    //       .color!
                    //       .withOpacity(0.64),
                    // ),
                  ],
                ),
              ),
            ),

            textController.text.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(left: kDefaultPadding / 2),
                    height: MediaQuery.of(context).size.width * 0.11,
                    child: FloatingActionButton(
                      splashColor: kContentColorDarkTheme,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      heroTag: ValueKey('send'),
                      backgroundColor: kPrimaryColor,
                      onPressed: () async {
                        if (textController.text.isNotEmpty) {
                          final data = {
                            "roomId": "${widget.roomId}",
                            "senderTo": "${widget.senderToId}",
                            "text": textController.text.trim()
                          };
                          final finish = await API(context).sendMsg(data);
                          if (finish) textController.clear();
                        }
                      },
                      child: Icon(
                        Icons.send,
                        size: 20,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
