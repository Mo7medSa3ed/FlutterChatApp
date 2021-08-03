import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';

class AudioRecordWidget extends StatelessWidget {
  const AudioRecordWidget({
    Key? key,
    @required this.status,
  }) : super(key: key);

  final RecordingStatus? status;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0x999999).withOpacity(.3),
          width: 3,
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            (status == RecordingStatus.Unset)
                ? Icons.mic
                : (status == RecordingStatus.Recording ||
                        status == RecordingStatus.Initialized)
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
            color: Colors.white,
            size: status == RecordingStatus.Unset ? 25 : 40,
          ),
        ),
      ),
    );
  }
}
