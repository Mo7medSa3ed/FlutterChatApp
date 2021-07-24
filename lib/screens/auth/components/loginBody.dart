import 'package:chat/components/primary_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/screens/auth/components/primaryField.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final phoneController = TextEditingController(text: '');
  final passController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
        child: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            Image.asset(
              !isDark
                  ? "assets/images/Logo_light.png"
                  : "assets/images/Logo_dark.png",
              height: 146,
              width: double.infinity,
            ),
            Spacer(
              flex: 1,
            ),
            Text(
              "Sign in",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyText1!.color!),
            ),
            SizedBox(
              height: kDefaultPadding * 3,
            ),
            PrimaryField(
              hint: 'Phone',
              controller: phoneController,
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            PrimaryField(
              hint: 'Password',
              controller: passController,
            ),
            SizedBox(
              height: kDefaultPadding * 2,
            ),
            PrimaryButton(
              text: "Sign In",
              press: () {},
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don\'t Have An account ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyText1!.color!),
                ),
                SizedBox(
                  width: kDefaultPadding / 2,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Sign up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
