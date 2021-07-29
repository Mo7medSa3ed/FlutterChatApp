import 'dart:convert';

import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/welcome/splashScrean.dart';
import 'package:chat/socket.dart';
import 'package:chat/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  if (!Socket().socket.connected) {
    Socket().socket.connect();
  }
  runApp(ChangeNotifierProvider<AppProvider>(
      create: (_) => AppProvider(), builder: (ctx, w) => MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    Socket().socket.on('ChangeUserStatus', (data) {
      Provider.of<AppProvider>(context, listen: false)
          .initUser(User.fromJson(data));
    });
    Socket().socket.on('NewMessage', (msg) {
      final uid = Provider.of<AppProvider>(context, listen: false).user!.id;
      final isSender = msg['senderTo'] != uid;
      if (isSender) {
        ChatMessage data = ChatMessage.fromJson(msg, isSender);
        Provider.of<AppProvider>(context, listen: false).addMsgTochat(data);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final user = Provider.of<AppProvider>(context, listen: false).user;

    if (user != null && user.id != null) {
      if (state == AppLifecycleState.detached) {
        Socket().emitDisonline(user.id);
      }
      if (state == AppLifecycleState.inactive) {
        Socket().emitDisonline(user.id);
      }
      if (state == AppLifecycleState.paused) {
        Socket().emitDisonline(user.id);
      }
      if (state == AppLifecycleState.resumed) {
        if (!Socket().socket.connected) {
          Socket().socket.connect();
          Socket().emitOnline(user.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: SplashScrean(),
      ),
    );
  }
}
