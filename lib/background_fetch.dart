import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:chat/encreption.dart';
import 'package:chat/models/User.dart';
import 'package:chat/notification.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initPlatformState() async {
  // Configure BackgroundFetch.
  try {
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 1,
          startOnBoot: true,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY,
        ),
        onBackgroundFetch,
        onBackgroundFetchTimeout);
    BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.example.chat",
      delay: 1,
      periodic: true,
      forceAlarmManager: true,
      startOnBoot: true,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
    ));
  } catch (e) {
    // print("[BackgroundFetch] configure ERROR: $e");
  }
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    // print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  onBackgroundFetch(taskId);
  // print("[BackgroundFetch] Headless event received2: $taskId");
  BackgroundFetch.finish(taskId);
}

void onBackgroundFetch(String taskId) async {
  if (taskId == 'com.example.chat') {
    final prfs = await SharedPreferences.getInstance();
    final userGetter = prfs.get('user');
    User? user = userGetter != null
        ? User.fromJson(jsonDecode(userGetter.toString()))
        : null;
    bool online = prfs.getBool('online') ?? false;

    if (online == false) {
      // print("inside service");
      final dio = new Dio();
      final res = await dio.get(
          'https://chatserver1235.herokuapp.com/messages/${user!.id}',
          options: Options(responseType: ResponseType.json));
      if ([200, 201].contains(res.statusCode)) {
        res.data.forEach((e) async {
          if (e['senderId'] != user.id) {
            await notificationPlugin.showNotification(res.data.indexOf(e),
                e['senderName'], Encreption.decreptAES(e['text']), e['roomId']);
          }
        });
      }
    }
  }
  // if reciever
  //if (taskId == 'com.example.chat') {
  //await notificationPlugin.showNotification(
  //  1, "data['recieverName']", "sadajl", "msg['roomId']");
  // if (!Socket().socket.connected) {
  //   Socket().socket.connect();
  //   Socket().socket.on('NewMessage', (data) async {
  //     final msg = data['message'];
  //     final prfs = await SharedPreferences.getInstance();
  //     final userGetter = prfs.get('user');
  //     User? user = userGetter != null
  //         ? User.fromJson(jsonDecode(userGetter.toString()))
  //         : null;
  //     if (msg['senderTo'] == user!.id) {
  //       var count = data['count'];

  //       if (count > 0) {
  //         FlutterAppBadger.updateBadgeCount(count);
  //       } else {
  //         FlutterAppBadger.removeBadge();
  //       }

  //       await notificationPlugin.showNotification(
  //           count,
  //           data['recieverName'],
  //           Encreption.decreptAES(msg['text']) ?? msg['attachLink'],
  //           msg['roomId']);
  //     }
  //   });
  // }
  //}

  BackgroundFetch.finish(taskId);
}

/// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
void onBackgroundFetchTimeout(String taskId) {
  // print("[BackgroundFetch] TIMEOUT: $taskId");
  BackgroundFetch.finish(taskId);
}
