import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didRecievedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;
  NotificationPlugin._() {
    init();
  }

  init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermision();
    }

    initializePlatformSpecifics();
  }

  void _requestIOSPermision() {
    flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  void initializePlatformSpecifics() {
    var initializeSettingAndroid = AndroidInitializationSettings('logo');
    var initializeSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, payload: payload, body: body);

          didRecievedLocalNotificationSubject.add(receivedNotification);
        });

    initializationSettings = InitializationSettings(
        android: initializeSettingAndroid, iOS: initializeSettingIOS);
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      await onNotificationClick(payload);
    });
  }

  setListnerForLowerVersions(Function onNotificationInlowerVersions) {
    didRecievedLocalNotificationSubject.listen((value) {
      onNotificationInlowerVersions(value);
    });
  }

  Future<void> showNotification(id, title, body, payload) async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESC',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();

    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    await flutterLocalNotificationsPlugin!
        .show(id, title, body, platformChannel, payload: payload+"$id");
  }
}


// Future<String> downloadAndSaveFile(String url) async {
//   String fileName = url.split('/').last;

//   final Directory directory = await getApplicationDocumentsDirectory();
//   final String filePath = '${directory.path}/$fileName';
//   final http.Response response = await http.get(Uri.parse(url));
//   final File file = File(filePath);
//   await file.writeAsBytes(response.bodyBytes);
//   return filePath;
// }

// Future<void> showNotificationWithAttachment({
//   @required int id,
//   @required String title,
//   @required String body,
//   @required int chatId,
//   @required String type,
//   String image,
// }) async {
//   String bigPicturePath;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   if (image != null) bigPicturePath = await downloadAndSaveFile(image);
//   const Person me = Person(
//     name: 'Me',
//     key: '1',
//     // uri: 'tel:1234567890',
//     icon: DrawableResourceAndroidIcon('me'),
//   );
//   final Person lunchBot = Person(
//     name: title,
//     key: type,
//     // bot: true,
//     icon: BitmapFilePathAndroidIcon(bigPicturePath),
//   );
//   final List<Message> messages = <Message>[
//     Message(body, DateTime.now(), lunchBot),
//   ];
//   final MessagingStyleInformation messagingStyle = MessagingStyleInformation(me,
//       groupConversation: true,
//       conversationTitle: ' ',
//       htmlFormatContent: true,
//       htmlFormatTitle: true,
//       messages: messages);

//   final AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     '$chatId',
//     'your channel name',
//     'your channel description',
//     importance: Importance.max,
//     priority: Priority.high,
//     ticker: 'ticker',
//     visibility: NotificationVisibility.private,
//     styleInformation: messagingStyle,
//   );

//   final IOSNotificationDetails iOSPlatformChannelSpecifics =
//       IOSNotificationDetails(
//           threadIdentifier: 'notify-$chatId',
//           attachments: <IOSNotificationAttachment>[
//         if (bigPicturePath != null && bigPicturePath.isNotEmpty)
//           IOSNotificationAttachment(bigPicturePath)
//       ]);
//   final MacOSNotificationDetails macOSPlatformChannelSpecifics =
//       MacOSNotificationDetails(
//           threadIdentifier: 'notify-$chatId',
//           attachments: <MacOSNotificationAttachment>[
//         if (bigPicturePath != null && bigPicturePath.isNotEmpty)
//           MacOSNotificationAttachment(bigPicturePath)
//       ]);

//   final NotificationDetails notificationDetails = NotificationDetails(
//       iOS: iOSPlatformChannelSpecifics,
//       macOS: macOSPlatformChannelSpecifics,
//       android: androidPlatformChannelSpecifics);

//   flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails,
//       payload: '$type-$chatId');
// }

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({this.body, this.id, this.payload, this.title});
}
