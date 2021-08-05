import 'package:chat/components/filled_outline_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/room.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  List<Room>? chats;
  List<Room>? filteredChats = [];
  bool pressed = true;
  var uid;
  // AnimationController? controller;
  // Animation<Offset>? offset;
  @override
  void initState() {
    uid = Provider.of<AppProvider>(context, listen: false).user!.id;
    getRoom();
    // controller =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    // offset = Tween<Offset>(
    //   begin: Offset(1.0, 0),
    //   end: Offset.zero,
    // ).animate(controller!);

    super.initState();
  }

  getRoom() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      filteredChats = provider.roomList;
    });
  }

  @override
  void dispose() {
    //controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (Provider.of<AppProvider>(context, listen: false).search) {
    //   controller!.reset();
    //   controller!.forward();
    // } else if (!Provider.of<AppProvider>(context, listen: false).search) {
    //   controller!.reset();
    //   controller!.forward();
    // }
    return Consumer<AppProvider>(builder: (ctx, pro, w) {
      chats = pro.roomList;

      return Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: kPrimaryColor,
            child: !pro.search
                ? DelayedDisplay(
                    delay: Duration(milliseconds: 100),
                    fadeIn: true,
                    child: Row(
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
                    ),
                  )
                : DelayedDisplay(
                    delay: Duration(milliseconds: 100),
                    fadeIn: true,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 1.5),
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
                    )),
          ),
          (chats != null && chats!.length > 0)
              ? Expanded(
                  child: ListView.builder(
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
                      }),
                )
              : Expanded(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 3),
                    child: Text(
                      "Hi you don't have any chats search for firends to chat with them.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, letterSpacing: 2),
                    ),
                  )),
                ),
        ],
      );
    });
  }
}
