import 'package:chat/api.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/socket.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class ChatInputField extends StatefulWidget {
  final senderToId;
  ChatInputField({
    Key? key,
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
                        onChanged: (String v) {
                          if (v.length == 1|| v.length==0 ) {
                            final chatList =
                                Provider.of<AppProvider>(context, listen: false)
                                    .chatList;
                            if (chatList.length > 0) {
                              Socket().emitChangeStatus({
                                'roomId': chatList[0].roomId,
                                'reciever': "${widget.senderToId}",
                                'status': v.length==0?null: 'typing...'
                              });
                            }
                          }
                        },
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
                          final chatList =
                              Provider.of<AppProvider>(context, listen: false)
                                  .chatList;
                          final rid =
                              chatList.length > 0 ? chatList[0].roomId : null;
                          final data = {
                            "roomId": rid,
                            "senderTo": "${widget.senderToId}",
                            "text": textController.text.trim()
                          };
                          final finish = await API(context).sendMsg(data);
                          if (finish) {
                            textController.clear();
                            Socket().emitChangeStatus({
                              'roomId': chatList[0].roomId,
                              'reciever': "${widget.senderToId}",
                              'status': null
                            });
                          }
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
