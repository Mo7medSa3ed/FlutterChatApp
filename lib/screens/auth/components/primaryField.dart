import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class PrimaryField extends StatefulWidget {
  final controller;
  final hint;
  PrimaryField({this.hint, this.controller});

  @override
  _PrimaryFieldState createState() => _PrimaryFieldState();
}

class _PrimaryFieldState extends State<PrimaryField> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultPadding * 2),
          color: kContentColorDarkTheme.withOpacity(isDark ? 0.1 : 1)),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? v) {
          if (widget.hint.toString().toLowerCase() == 'password') {
            if (v!.isEmpty) {
              return '${widget.hint.toString().toLowerCase()} is required';
            } else if (v.length < 6) {
              return '${widget.hint.toString().toLowerCase()} at least 6 character';
            } else {
              return null;
            }
          }
          if (widget.hint.toString().toLowerCase() == 'phone') {
            if (v!.isEmpty) {
              return '${widget.hint.toString().toLowerCase()} is required';
            } else if (v.length < 11) {
              return '${widget.hint.toString().toLowerCase()} at least 11 number';
            } else {
              return null;
            }
          }
          return null;
        },
        controller: widget.controller,
        obscureText:
            widget.hint.toString().toLowerCase() == 'password' ? true : false,
        maxLength: widget.hint.toString().toLowerCase() == 'phone' ? 11 : null,
        keyboardType: widget.hint.toString().toLowerCase() == 'phone'
            ? TextInputType.phone
            : TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: widget.hint, counterText: ''),
      ),
    );
  }
}
