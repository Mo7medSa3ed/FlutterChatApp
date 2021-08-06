import 'package:audioplayers/audioplayers.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class AudioMessage extends StatefulWidget {
  final ChatMessage? message;
  AudioMessage({Key? key, this.message}) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  AudioPlayer audioPlayer = AudioPlayer();

  PlayerState audioPlayerState = PlayerState.PAUSED;

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;

  /// Optional
  Widget slider() {
    return Slider.adaptive(
        inactiveColor: (!widget.message!.isSender
                ? kPrimaryColor
                : kContentColorLightTheme)
            .withOpacity(0.6),
        activeColor: audioPlayerState != PlayerState.PAUSED
            ? !widget.message!.isSender
                ? kPrimaryColor
                : kContentColorLightTheme
            : kContentColorDarkTheme,
        value: timeProgress.toDouble(),
        max: audioDuration.toDouble(),
        onChanged: (value) {
          seekToSec(value.toInt());
        });
  }

  @override
  void initState() {
    super.initState();

    /// Compulsory
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted)
        setState(() {
          audioPlayerState = state;
        });
    });

    /// Optional
    audioPlayer.setUrl(widget.message!
        .attachLink!); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inMilliseconds;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inMilliseconds;
      });
    });
  }

  /// Compulsory
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  /// Compulsory
  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    await audioPlayer.play(widget.message!.attachLink!);
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(milliseconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kPrimaryColor.withOpacity(widget.message!.isSender ? 1 : 0.1),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  iconSize: 50,
                  onPressed: () {
                    audioPlayerState == PlayerState.PLAYING
                        ? pauseMusic()
                        : playMusic();
                  },
                  icon: Icon(
                    audioPlayerState == PlayerState.PLAYING
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: audioPlayerState != PlayerState.PAUSED
                        ? !widget.message!.isSender
                            ? kPrimaryColor
                            : kContentColorLightTheme
                        : kContentColorDarkTheme,
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  slider(),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(getTimeString((timeProgress / 1000).toInt())),
                        Spacer(),
                        Text(getTimeString((audioDuration / 1000).toInt())),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ))
            ]));
  }
}
