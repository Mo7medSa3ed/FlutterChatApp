import 'package:chat/constants.dart';
import 'package:chat/screens/profile/components/editBody.dart';
import 'package:flutter/material.dart';

class EditProfileScrean extends StatelessWidget {
  const EditProfileScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: EditBody(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: true,
      title: Text("Edit Profile",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).textTheme.bodyText1!.color!)),
    );
  }
}
