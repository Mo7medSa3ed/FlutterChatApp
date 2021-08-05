import 'dart:convert';
import 'package:chat/api.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/User.dart';
import 'package:chat/notification.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:chat/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:chat/screens/welcome/welcome_screen.dart';
import 'package:chat/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScrean extends StatefulWidget {
  const SplashScrean({Key? key}) : super(key: key);

  @override
  _SplashScreanState createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  @override
  void initState() {
    check();

    super.initState();
  }

  onNotificationInlowerVersions(ReceivedNotification receivedNotification) {}

  Future onNotificationClick(String payload) async {
    goTo(context, MessagesScreen(User(), payload));
  }

  getRoom() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (provider.roomList == null) {
      final id = provider.user?.id;
      await API(context).getAllChats(id);
      setState(() {});
    }
  }

  check() async {
    final prfs = await SharedPreferences.getInstance();
    final userGetter = prfs.get('user');
    User? user = userGetter != null
        ? User.fromJson(jsonDecode(userGetter.toString()))
        : null;
    if (user != null && user.id != null && user.phone != null) {
      final newUser = await API(context).getUser(user.id);

      if (newUser != 'error' && newUser != null) {
        if (newUser.updatedAt == user.updatedAt) {
          Provider.of<AppProvider>(context, listen: false).initUser(user);
          Socket().emitOnline(user.id);
          await getRoom();
          notificationPlugin
              .setListnerForLowerVersions(onNotificationInlowerVersions);
          notificationPlugin.setOnNotificationClick(onNotificationClick);
          goToWithRemoveUntill(context, ChatsScreen());
        } else {
          goToWithRemoveUntill(context, SigninOrSignupScreen());
        }
      } else if (newUser == 'error') {
        goToWithRemoveUntill(context, SigninOrSignupScreen());
      }
    } else {
      if (prfs.getBool('first') ?? true) {
        goToWithRemoveUntill(context, WelcomeScreen());
      } else {
        goToWithRemoveUntill(context, SigninOrSignupScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/images/Logo_light.png"
                  : "assets/images/Logo_dark.png",
              height: 146,
            ),
            CircularProgressIndicator(
              color: kPrimaryColor,
            )
          ],
        ),
      ),
    );
  }
}
