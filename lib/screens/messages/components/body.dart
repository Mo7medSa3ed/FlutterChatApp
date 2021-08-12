import 'package:chat/api.dart';
import 'package:chat/constants.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/messages/components/chat_input_field.dart';
import 'package:chat/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  int page = 0;
  final paginateScrollController = ScrollController();
  bool? isLast = false;
  var uid;
  @override
  void dispose() {
    if (widget.roomId != null)
      Socket().emitlastOPenForRoom(
          {"id": widget.roomId, "open": false, "senderId": uid});
    super.dispose();
  }

  @override
  void initState() {
    uid = Provider.of<AppProvider>(context, listen: false).user!.id;
    if (widget.roomId != null)
      Socket().emitlastOPenForRoom(
          {"id": widget.roomId, "open": true, "senderId": uid});
    Provider.of<AppProvider>(context, listen: false).chatList.clear();
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
      isLast = await API(context).getAllMessages(widget.roomId, page + 1);
  }

  @override
  Widget build(BuildContext context) {
    var messageList =
        Provider.of<AppProvider>(context, listen: true).getChatList();
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
                itemBuilder: (ctx, index) =>
                    Message(message: messageList[index], img: widget.image),
              ),
            ),
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          ChatInputField(
            senderToId: widget.senderToId,
            roomId: widget.roomId,
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////
