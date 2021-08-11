import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 16.0;

const img =
    "https://www.clipartkey.com/mpngs/m/301-3011907_profile-image-placeholder-circle-png.png";

goTo(context, screan) {
  print("Go to second screan");
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

saveMsgIdForPrfs(value) async {
  final prfs = await SharedPreferences.getInstance();
  var list = prfs.getStringList('unread') ?? [];
  list.add(value.toString());
  await prfs.setStringList('unread', list);
}

removeMsgIdForPrfs(unreadList) async {
  final prfs = await SharedPreferences.getInstance();
  var list = prfs.getStringList('unread') ?? [];
  unreadList.forEach((e) => list.remove(e));
  await prfs.setStringList('unread', list);
}

isContain(id) async {
  final prfs = await SharedPreferences.getInstance();
  var list = prfs.getStringList('unread') ?? [];

  return list.contains(id);
}

setBoolValue(key, value) async {
  final prfs = await SharedPreferences.getInstance();
  return prfs.setBool(key, value);
}

clearPrfs() async {
  final prfs = await SharedPreferences.getInstance();
  prfs.clear();
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
    return 'Just now';
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
      " " +
      DateFormat.Hm().format(DateTime.parse(date).toLocal()).toString();
}

download(String url, type) async {
  if (url.isNotEmpty && type != 'text') {
    final folderName = "Chaty";
    var dir = await getExternalStorageDirectory();
    final path =
        Directory("${dir!.path}/$folderName/${type}s/${url.split('/').last}");
    if (!(await path.exists())) {
      await Dio().download(url, path.path);
    }
  }
  return Future.value(url);
}
