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

  runApp(MyApp());
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
    if (state == AppLifecycleState.detached) {
      // Socket().emitDisonline("60ff9c35bc4853196785b05b");
      print('deattach');
    }
    if (state == AppLifecycleState.inactive) {
      //Socket().emitDisonline("60ff9c35bc4853196785b05b");
      print('inactive');
    }
    if (state == AppLifecycleState.paused) {
      //Socket().emitDisonline("60ff9c35bc4853196785b05b");
      print('paused');
    }
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      //Socket().emitDisonline("60ff9c35bc4853196785b05b");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (_) => AppProvider(),
      builder: (ctx, w) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: MaterialApp(
          title: 'Chat App',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: lightThemeData(ctx),
          darkTheme: darkThemeData(ctx),
          home: SplashScrean(),
        ),
      ),
    );
  }
}
