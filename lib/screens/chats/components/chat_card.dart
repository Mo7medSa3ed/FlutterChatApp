import 'package:chat/Alert.dart';
import 'package:chat/api.dart';
import 'package:chat/models/room.dart';
import 'package:chat/provider/app_provider.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class ChatCard extends StatelessWidget {
  ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Room chat;
  final VoidCallback press;
  var reciever;
  var uid;

  @override
  Widget build(BuildContext context) {
    uid = Provider.of<app.AppProvider>(context, listen: false).user!.id;

    if (chat.reciverId!.id == uid) {
      reciever = chat.userId;
    } else {
      reciever = chat.reciverId;
    }

    return Dismissible(
      key: ObjectKey(chat),
      confirmDismiss: (t) async {
        var success = false;
        await Alert.warningAlert(
            ctx: context,
            confirm: () async {
              Navigator.of(context).pop();
              success = await API(context).deleteChat(chat.id);
            });

        return Future.value(success);
      },
      background: Container(
        padding: EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
        color: kErrorColor,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.startToEnd,
      child: InkWell(
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(reciever.img ?? img),
                  ),
                  if (reciever.online ?? false)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 3),
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reciever.name ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Opacity(
                        opacity: 0.6,
                        child: Text(
                          chat.recieverStatus != null
                              ? chat.recieverStatus!
                              : (chat.lastMessage!.text ?? ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Opacity(
                      opacity: 0.64,
                      child: Text(DateFormat('h m a')
                          .format(DateTime.parse(chat.updatedAt.toString())))),
                  SizedBox(height: chat.msgCount == 0 ? 0 : 5),
                  chat.msgCount == 0
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: kPrimaryColor),
                          child: Text(
                            chat.msgCount! > 99
                                ? '+99'
                                : chat.msgCount.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
