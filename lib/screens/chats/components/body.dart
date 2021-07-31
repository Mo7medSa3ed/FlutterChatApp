import 'package:chat/api.dart';
import 'package:chat/components/filled_outline_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/room.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Room>? chats;
  List<Room>? filteredChats = [];
  bool pressed = true;
  var uid;
  @override
  void initState() {
    uid = Provider.of<AppProvider>(context, listen: false).user!.id;
    getRoom();
    super.initState();
  }

  getRoom() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (provider.roomList == null) {
      final id = provider.user?.id;
      filteredChats = await API(context).getAllChats(id);
      setState(() {});
    } else {
      filteredChats = provider.roomList;
    }
  }

  @override
  Widget build(BuildContext context) {
    var search = context.select<AppProvider, bool>((value) => value.search);

    return Consumer<AppProvider>(builder: (ctx, pro, w) {
      chats = pro.roomList;

      return Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: kPrimaryColor,
            child: !search
                ? Row(
                    children: [
                      FillOutlineButton(
                          isFilled: pressed,
                          press: () {
                            filteredChats = chats;
                            pressed = true;
                            setState(() {});
                          },
                          text: "Recent Message"),
                      SizedBox(width: kDefaultPadding),
                      FillOutlineButton(
                        isFilled: !pressed,
                        press: () {
                          var filtered = chats!
                              .where((e) =>
                                  e.reciverId!.online! || e.userId!.online!)
                              .toList();

                          filteredChats = filtered;
                          pressed = false;
                          setState(() {});
                        },
                        text: "Active",
                      ),
                    ],
                  )
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(ctx)
                            .scaffoldBackgroundColor
                            .withOpacity(0.5)),
                    child: TextField(
                      maxLength: 20,
                      onChanged: (String val) {
                        if (val.length > 0) {
                          var filtered = chats!
                              .where((e) =>
                                  e.reciverId!.name!
                                      .toLowerCase()
                                      .contains(val.trim().toLowerCase()) ||
                                  e.reciverId!.phone!
                                      .toLowerCase()
                                      .contains(val.trim().toLowerCase()))
                              .toList();

                          filteredChats = filtered;
                        } else {
                          filteredChats = chats;
                        }
                        setState(() {});
                      },
                      cursorColor: Theme.of(ctx).textTheme.bodyText1!.color!,
                      maxLines: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: "Search here...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
          ),
          Expanded(
              child: (chats != null && chats!.length > 0)
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: filteredChats?.length,
                      itemBuilder: (ctx, index) {
                        var reciever;
                        if (filteredChats![index].reciverId!.id == uid) {
                          reciever = filteredChats![index].userId;
                        } else {
                          reciever = filteredChats![index].reciverId;
                        }
                        return ChatCard(
                          chat: filteredChats![index],
                          press: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (ctx) => MessagesScreen(
                                reciever,
                                filteredChats![index].id,
                              ),
                            ),
                          ),
                        );
                      })
                  : (chats == null)
                      ? Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        )
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 3),
                          child: Text(
                            "Hi you don't have any chats search for firends to chat with them.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, letterSpacing: 2),
                          ),
                        ))),
        ],
      );
    });
  }
}
