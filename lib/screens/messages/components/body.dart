import 'package:chat/api.dart';
import 'package:chat/constants.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatefulWidget {
  final roomId;
  final senderToId;
  Body(this.roomId, this.senderToId,);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    getMessages();

    super.initState();
  }

  getMessages() async {
    await API(context).getAllMessages(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    var messageList = Provider.of<AppProvider>(context).getChatList();
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: messageList.length,
                itemBuilder: (ctx, index) =>
                    Message(message: messageList[index]),
              ),
            ),
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          ChatInputField(
            roomId: widget.roomId,
            senderToId: widget.senderToId,
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////
