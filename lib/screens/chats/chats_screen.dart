import 'package:chat/constants.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/chats/components/peobleBody.dart';
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
      title: Text("Chat App"),
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
