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

  @override
  void initState() {
    getRoom();
    super.initState();
  }

  getRoom() async {
    final id = Provider.of<AppProvider>(context, listen: false).user?.id;
    chats = await API(context).getAllChats(id);
    filteredChats = chats;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var search = context.select<AppProvider, bool>((value) => value.search);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: !search
              ? Row(
                  children: [
                    FillOutlineButton(press: () {}, text: "Recent Message"),
                    SizedBox(width: kDefaultPadding),
                    FillOutlineButton(
                      press: () {},
                      text: "Active",
                      isFilled: false,
                    ),
                  ],
                )
              : Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context)
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
                    cursorColor: Theme.of(context).textTheme.bodyText1!.color!,
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
          child: chats != null
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: filteredChats?.length,
                  itemBuilder: (context, index) => ChatCard(
                    chat: filteredChats![index],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagesScreen(
                          filteredChats![index].reciverId,
                          filteredChats![index].id,
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
        ),
      ],
    );
  }
}
