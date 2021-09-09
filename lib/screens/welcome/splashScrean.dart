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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class SplashScrean extends StatefulWidget {
  const SplashScrean({Key? key}) : super(key: key);

  @override
  _SplashScreanState createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  var subscription;
  @override
  void initState() {
    changeTheme();
    Connectivity().checkConnectivity().then((value) {
      if (value != ConnectivityResult.none) {
        check();
      } else {
        Fluttertoast.showToast(
            msg: 'No Internet Connection',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: kErrorColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        Fluttertoast.showToast(
            msg: 'Online',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: kPrimaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        check();
      } else {
        Fluttertoast.showToast(
            msg: 'No Internet Connection',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: kErrorColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });

    super.initState();
  }

  onNotificationInlowerVersions(ReceivedNotification receivedNotification) {}

  Future onNotificationClick(String payload) async {
    final id = payload.split('/').first;
    final pro = Provider.of<AppProvider>(context, listen: false);
    final idx = pro.roomList!.indexWhere((e) => e.id.toString() == id);
    goTo(context,
        MessagesScreen(idx != -1 ? pro.roomList![idx].reciverId! : User(), id));
  }

  getRoom() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (provider.roomList == null) {
      final id = provider.user?.id;
      await API(context).getAllChats(id);
    }
  }

  changeTheme() async {
    final prfs = await SharedPreferences.getInstance();
    Provider.of<AppProvider>(context, listen: false).dark =
        prfs.getBool('dark') ?? false;
  }

  check() async {
    final prfs = await SharedPreferences.getInstance();
prfs.clear();
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
  void dispose() {
    subscription.cancel();
    super.dispose();
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
