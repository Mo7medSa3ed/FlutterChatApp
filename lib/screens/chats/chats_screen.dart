import 'package:chat/constants.dart';
import 'package:chat/models/User.dart';
import 'package:chat/notification.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/chats/components/peobleBody.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:chat/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    notificationPlugin.clearAllNotification();
    notificationPlugin
        .setListnerForLowerVersions(onNotificationInlowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    super.initState();
  }

  onNotificationInlowerVersions(ReceivedNotification receivedNotification) {}

  Future onNotificationClick(String payload) async {
    print(payload);
    final id = payload.split('/').first;
    final pro = Provider.of<AppProvider>(context, listen: false);
    final idx = pro.roomList!.indexWhere((e) => e.id.toString() == id);
    goTo(context,
        MessagesScreen(idx != -1 ? pro.roomList![idx].reciverId! : User(), id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: [Body(), PeopleBody(), ProfileScrean()][_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              backgroundColor: kPrimaryColor,
              child: Icon(
                Icons.person_add_alt_1,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(
                Provider.of<AppProvider>(context, listen: false).user!.img ??
                    img),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: Text("Chaty"),
      actions: _selectedIndex == 0
          ? [
              IconButton(
                icon: Icon(
                    Provider.of<AppProvider>(context, listen: true).search
                        ? Icons.close
                        : Icons.search),
                onPressed: () {
                  Provider.of<AppProvider>(context, listen: false)
                      .changeSearch();
                },
              ),
            ]
          : null,
    );
  }
}
