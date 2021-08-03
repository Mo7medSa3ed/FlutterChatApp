import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 16.0;

const img =
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1868&q=80";

goTo(context, screan) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => screan));
}

goToWithReplaceMent(context, screan) {
  return Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => screan));
}

goToWithRemoveUntill(context, screan) {
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screan), (r) => false);
}

getValue(key) async {
  final prfs = await SharedPreferences.getInstance();
  return prfs.get(key);
}

setValue(key, value) async {
  final prfs = await SharedPreferences.getInstance();
  return prfs.setString(key, value);
}

setBoolValue(key, value) async {
  final prfs = await SharedPreferences.getInstance();
  return prfs.setBool(key, value);
}

showLoading(context) {
  return showDialog(
      context: context,
      builder: (ctx) => Center(
            child: CircularProgressIndicator(),
          ));
}

dateDiffrence(DateTime first, DateTime second) {
  final diff = DateTime.now().difference(second);
  if (diff.inMinutes == 0) {
    return 'JustNow';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} min ago';
  } else if (diff.inHours < 25) {
    return '${diff.inHours} hours ago';
  } else if (diff.inDays == 31) {
    return '${diff.inDays} day ago';
  } else {
    return '';
  }
}

dateTimeFormat(date) {
  return DateFormat.yMEd().format(DateTime.parse(date)) +
      DateFormat.Hm().format(DateTime.parse(date)).toString();
}
