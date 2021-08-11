import 'dart:io';
import 'package:chat/api.dart';
import 'package:chat/config/upload.dart';
import 'package:chat/models/message.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/messages/components/record_btn.dart';
import 'package:chat/socket.dart';
import 'package:chat/visulizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class ChatInputField extends StatefulWidget {
  final senderToId;
  ChatInputField({
    Key? key,
    this.senderToId,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final textController = TextEditingController(text: '');
  FlutterAudioRecorder2? recorder;
  File? recordFile;
  RecordingStatus status = RecordingStatus.Unset;
  @override
  void initState() {
    textController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  initRecording() async {
    if (!(await Permission.microphone.isGranted)) {
      await Permission.microphone.request();
    }
    if (await FlutterAudioRecorder2.hasPermissions ?? false) {
      final dir = await getApplicationDocumentsDirectory();

      recorder = FlutterAudioRecorder2(
          dir.path +
              '/' +
              DateTime.now().millisecondsSinceEpoch.toString() +
              '.aac',
          audioFormat: AudioFormat.AAC);
      await recorder!.initialized;
      setState(() {
        status = RecordingStatus.Initialized;
      });

      return true;
    } else {
      await Permission.microphone.request();
    }
    return false;
  }

  startRecording() async {
    if (await initRecording()) {
      setState(() {
        status = RecordingStatus.Recording;
      });
      recorder!.start();
      final chatList =
          Provider.of<AppProvider>(context, listen: false).getChatList();
      if (chatList.length > 0) {
        Socket().emitChangeStatus({
          'roomId': chatList[0].roomId,
          'reciever': "${widget.senderToId}",
          'status': 'Recording...'
        });
      }
    } else {
      print("you want to allow mic permission");
    }
  }

  stopRecording() async {
    Recording? res = await recorder!.stop();
    final chatList =
        Provider.of<AppProvider>(context, listen: false).getChatList();
    if (chatList.length > 0) {
      Socket().emitChangeStatus({
        'roomId': chatList[0].roomId,
        'reciever': "${widget.senderToId}",
        'status': null
      });
    }
    setState(() {
      status = RecordingStatus.Unset;
      recordFile = File(res!.path!);
    });
  }

  pauseRecording() async {
    await recorder!.pause();
    final chatList =
        Provider.of<AppProvider>(context, listen: false).getChatList();
    if (chatList.length > 0) {
      Socket().emitChangeStatus({
        'roomId': chatList[0].roomId,
        'reciever': "${widget.senderToId}",
        'status': null
      });
    }
    setState(() {
      status = RecordingStatus.Paused;
    });
  }

  resumeRecording() async {
    await recorder!.resume();
    final chatList =
        Provider.of<AppProvider>(context, listen: false).getChatList();
    if (chatList.length > 0) {
      Socket().emitChangeStatus({
        'roomId': chatList[0].roomId,
        'reciever': "${widget.senderToId}",
        'status': 'Recording...'
      });
    }
    setState(() {
      status = RecordingStatus.Recording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
        vertical: kDefaultPadding / 2 + 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            textController.text.isNotEmpty
                ? Container()
                : InkWell(
                    onTap: () async {
                      if (status == RecordingStatus.Unset ||
                          status == RecordingStatus.Stopped) {
                        await startRecording();
                      } else if (status == RecordingStatus.Recording) {
                        await pauseRecording();
                      } else if (status == RecordingStatus.Paused) {
                        await resumeRecording();
                      }
                    },
                    child: AudioRecordWidget(
                      status: status,
                    ),
                  ),
            SizedBox(width: kDefaultPadding / 2),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: kDefaultPadding / 2),
                    (status == RecordingStatus.Unset ||
                            status == RecordingStatus.Stopped)
                        ? Expanded(
                            child: TextField(
                              maxLines: 10,
                              minLines: 1,
                              textDirection: TextDirection.rtl,
                              controller: textController,
                              decoration: InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                              onChanged: (String v) {
                                if (v.length == 1 || v.length == 0) {
                                  final chatList = Provider.of<AppProvider>(
                                          context,
                                          listen: false)
                                      .getChatList();

                                  if (chatList.length > 0) {
                                    Socket().emitChangeStatus({
                                      'roomId': chatList[0].roomId,
                                      'reciever': "${widget.senderToId}",
                                      'status':
                                          v.length == 0 ? null : 'typing...'
                                    });
                                  }
                                }
                              },
                            ),
                          )
                        : !(status == RecordingStatus.Paused ||
                                status == RecordingStatus.Stopped)
                            ? Expanded(
                                child: MusicVisulizer(
                                animation: true,
                              ))
                            : Expanded(
                                child: MusicVisulizer(
                                animation: false,
                              )),
                    (status == RecordingStatus.Unset ||
                            status == RecordingStatus.Stopped)
                        ? IconButton(
                            onPressed: () async {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (builder) => bottomSheet());
                            },
                            icon: Icon(Icons.attach_file),
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          )
                        : IconButton(
                            onPressed: () async {
                              await stopRecording();
                            },
                            icon: Icon(Icons.delete),
                            color: kErrorColor.withOpacity(0.64),
                          ),
                  ],
                ),
              ),
            ),
            (textController.text.isNotEmpty ||
                    status == RecordingStatus.Paused ||
                    status == RecordingStatus.Recording)
                ? Container(
                    margin: EdgeInsets.only(left: kDefaultPadding / 2),
                    height: MediaQuery.of(context).size.width * 0.11,
                    child: FloatingActionButton(
                      splashColor: kContentColorDarkTheme,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      heroTag: ValueKey('send'),
                      backgroundColor: kPrimaryColor,
                      onPressed: () async {
                        var url;
                        if (status == RecordingStatus.Recording ||
                            status == RecordingStatus.Paused) {
                          await stopRecording();
                          url = await Cloud.upload(recordFile!);
                          recordFile = null;
                        }

                        if (textController.text.trim().isNotEmpty ||
                            url != null) {
                          final chatList =
                              Provider.of<AppProvider>(context, listen: false)
                                  .getChatList();
                          final rid =
                              chatList.length > 0 ? chatList[0].roomId : null;

                          final data = Message(
                              roomId: rid,
                              senderTo: "${widget.senderToId}",
                              text: url != null
                                  ? 'record'
                                  : textController.text.trim(),
                              type: url != null ? 'record' : 'text',
                              attachLink: url);

                          final finish =
                              await API(context).sendMsg(data.toJson());
                          if (finish) {
                            textController.clear();
                            if (chatList.length > 0) {
                              Socket().emitChangeStatus({
                                'roomId': chatList[0].roomId,
                                'reciever': "${widget.senderToId}",
                                'status': null
                              });
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: !isDark ? kContentColorDarkTheme : kContentColorLightTheme,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, Colors.indigo,
                      "Document", () {}),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera",
                      () async {
                    final result = await ImagePicker.platform
                        .pickImage(source: ImageSource.camera);
                    if (result != null) {
                      showLoading(context);
                      final res = await Cloud.upload(result);
                      if (res != null) {
                        final chatList =
                            Provider.of<AppProvider>(context, listen: false)
                                .getChatList();
                        final rid =
                            chatList.length > 0 ? chatList[0].roomId : null;

                        final data = Message(
                            roomId: rid,
                            senderTo: "${widget.senderToId}",
                            text: res != null
                                ? 'image'
                                : textController.text.trim(),
                            type: 'image',
                            attachLink: res);

                        await API(context).sendMsg(data.toJson());
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery",
                      () async {
                    final result = await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery);
                    if (result != null) {
                      showLoading(context);
                      final res = await Cloud.upload(result);
                      print(res);
                      if (res != null) {
                        final chatList =
                            Provider.of<AppProvider>(context, listen: false)
                                .getChatList();
                        final rid =
                            chatList.length > 0 ? chatList[0].roomId : null;

                        final data = Message(
                            roomId: rid,
                            senderTo: "${widget.senderToId}",
                            text: res != null
                                ? 'image'
                                : textController.text.trim(),
                            type: 'image',
                            attachLink: res ?? '');

                        await API(context).sendMsg(data.toJson());
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio", () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.audio,
                    );
                    if (result != null) {
                      if (result.count > 0) {
                        showLoading(context);
                        final res = await Cloud.upload(result.files.first);
                        if (res != null) {
                          final chatList =
                              Provider.of<AppProvider>(context, listen: false)
                                  .getChatList();
                          final rid =
                              chatList.length > 0 ? chatList[0].roomId : null;

                          final data = Message(
                              roomId: rid,
                              senderTo: "${widget.senderToId}",
                              text: res != null
                                  ? 'audio'
                                  : textController.text.trim(),
                              type: 'audio',
                              attachLink: res ?? '');

                          await API(context).sendMsg(data.toJson());
                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    }
                  }),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                      Icons.smart_display, Colors.teal, "Gallery\nVideo",
                      () async {
                    final result = await ImagePicker.platform
                        .pickVideo(source: ImageSource.gallery);
                    if (result != null) {
                      showLoading(context);
                      final res = await Cloud.upload(result);
                      if (res != null) {
                        final chatList =
                            Provider.of<AppProvider>(context, listen: false)
                                .getChatList();
                        final rid =
                            chatList.length > 0 ? chatList[0].roomId : null;

                        final data = Message(
                            roomId: rid,
                            senderTo: "${widget.senderToId}",
                            text: res != null
                                ? 'video'
                                : textController.text.trim(),
                            type: 'video',
                            attachLink: res ?? '');

                        await API(context).sendMsg(data.toJson());
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                      Icons.smart_display, Colors.teal, "Camera\nVideo",
                      () async {
                    final result = await ImagePicker.platform
                        .pickVideo(source: ImageSource.camera);
                    if (result != null) {
                      showLoading(context);
                      final res = await Cloud.upload(result);
                      if (res != null) {
                        final chatList =
                            Provider.of<AppProvider>(context, listen: false)
                                .getChatList();
                        final rid =
                            chatList.length > 0 ? chatList[0].roomId : null;

                        final data = Message(
                            roomId: rid,
                            senderTo: "${widget.senderToId}",
                            text: res != null
                                ? 'video'
                                : textController.text.trim(),
                            type: 'video',
                            attachLink: res ?? '');

                        await API(context).sendMsg(data.toJson());
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text, ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyText1!.color!
                // fontWeight: FontWeight.w100,
                ),
          )
        ],
      ),
    );
  }
}
/**
 * () async {
                    final result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: [
                          'doc',
                          'docx',
                          'html',
                          'htm',
                          'odt',
                          'pdf',
                          'xlsx',
                          'xls',
                          'ods',
                          'ppt',
                          'pptx',
                          'txt'
                        ]);
                    if (result != null) {
                      if (result.count > 0) {
                        showLoading(context);
                        final res = await Cloud.upload(result.files.first);

                        if (res != null) {
                          final chatList =
                              Provider.of<AppProvider>(context, listen: false)
                                  .chatList;
                          final rid =
                              chatList.length > 0 ? chatList[0].roomId : null;

                          final data = Message(
                              roomId: rid,
                              senderTo: "${widget.senderToId}",
                              type: 'document',
                              attachLink: res ?? '');

                          await API(context).sendMsg(data.toJson());
                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    }
 * 
 */