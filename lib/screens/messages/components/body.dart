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
  final image;
  Body(
    this.roomId,
    this.senderToId,
    this.image,
  );
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int page = 1;
  final paginateScrollController = ScrollController();
  bool? isLast = false;
  @override
  void initState() {
    getMessages();
    paginateScrollController.addListener(() {
      setState(() {
        if (paginateScrollController.position.pixels ==
            paginateScrollController.position.maxScrollExtent) {
          page = page + 1;
          getMessages();
        }
      });
    });
    super.initState();
  }

  getMessages() async {
    if (widget.roomId != null && isLast == false)
      isLast = await API(context).getAllMessages(widget.roomId, page);
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
                controller: paginateScrollController,
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: messageList.length,
                itemBuilder: (ctx, index) => Message(
                  message: messageList[index],
                  img: widget.image,
                ),
              ),
            ),
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          ChatInputField(
            senderToId: widget.senderToId,
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////
