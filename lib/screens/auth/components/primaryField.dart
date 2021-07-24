import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class PrimaryField extends StatefulWidget {
 
  final controller;
  final hint;
  PrimaryField({this.hint,this.controller});

  @override
  _PrimaryFieldState createState() => _PrimaryFieldState();
}

class _PrimaryFieldState extends State<PrimaryField> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 2, vertical: kDefaultPadding / 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: kContentColorDarkTheme.withOpacity(isDark ? 0.1 : 1)),
      child: TextFormField(
        controller: widget.controller,
        decoration:
            InputDecoration(border: InputBorder.none, hintText: widget.hint),
      ),
    );
  }
}
