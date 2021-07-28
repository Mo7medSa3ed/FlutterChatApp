import 'package:chat/constants.dart';
import 'package:chat/screens/profile/components/editBody.dart';
import 'package:flutter/material.dart';

class EditProfileScrean extends StatelessWidget {
  const EditProfileScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: EditBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: true,
      title: Text("Edit Profile"),
    );
  }
}
