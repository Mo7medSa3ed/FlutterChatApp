import 'package:chat/models/ChatMessage.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMessage extends StatefulWidget {
  final ChatMessage? message;
  VideoMessage({this.message});
  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  final link =
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4';

  FlickManager? flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: false,
      autoInitialize: true,
      videoPlayerController: VideoPlayerController.network(link),
    );
  }

  @override
  void dispose() {
    flickManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(flickManager: flickManager!);
  }
}
