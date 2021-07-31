import 'package:chat/Alert.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:chat/models/room.dart';
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
      print(data);
      final pro = Provider.of<AppProvider>(context, listen: false);
      pro.initUser(User.fromJson(data));
      pro.changeUserStatusForRoom(User.fromJson(data));
    });

    Socket().socket.on('changeStatusForUser', (data) {
      final pro = Provider.of<AppProvider>(context, listen: false);
      pro.changeUserStatus(data);
    });

    Socket().socket.on('NewMessage', (data) {
      final msg = data['message'];
      final provider = Provider.of<AppProvider>(context, listen: false);
      final uid = provider.user!.id;
      final isSender = msg['senderTo'] == uid;

      if (isSender) {
        if (data['room'] != null) {
          provider
              .addRoom(Room.fromJson(data['room'], msgs: false, lastMsg: msg));
        }
        ChatMessage newMsg = ChatMessage.fromJson(msg, !isSender);
        provider.addMsgTochat(newMsg);
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
        }
        Socket().emitOnline(user.id);
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
