import 'dart:async';
import 'package:chat/constants.dart';
import 'package:flutter/cupertino.dart';

class MusicVisulizer extends StatelessWidget {
  final animation;
  MusicVisulizer({Key? key, this.animation}) : super(key: key);
  final list2 = [200, 500, 300, 700, 400, 900, 600, 800];
  @override
  Widget build(BuildContext context) {
    if (animation) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: new List<Widget>.generate(
              20,
              (index) => VisualComponent(
                    animation: animation,
                    duration: list2[index % 5],
                  )));
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: new List<Widget>.generate(
              20,
              (index) => StaticVisualComponent(
                    animation: animation,
                    duration: list2[index % 5],
                  )));
    }
  }
}

class VisualComponent extends StatefulWidget {
  const VisualComponent({Key? key, this.duration, this.animation})
      : super(key: key);
  final duration;
  final animation;
  @override
  _VisualComponentState createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    animation = Tween<double>(begin: 0, end: 40)
        .animate(CurvedAnimation(curve: Curves.easeInOut, parent: controller!))
          ..addListener(() {
            setState(() {});
          });
    controller!.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: animation!.value,
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
    );
  }
}

class StaticVisualComponent extends StatefulWidget {
  const StaticVisualComponent({Key? key, this.duration, this.animation})
      : super(key: key);
  final duration;
  final animation;
  @override
  _StaticVisualComponentState createState() => _StaticVisualComponentState();
}

class _StaticVisualComponentState extends State<StaticVisualComponent>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    animation = Tween<double>(begin: 0, end: 40)
        .animate(CurvedAnimation(curve: Curves.easeInOut, parent: controller!))
          ..addListener(() {
            setState(() {});
          });
    controller!.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      controller!.stop();
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: animation!.value,
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
    );
  }
}
