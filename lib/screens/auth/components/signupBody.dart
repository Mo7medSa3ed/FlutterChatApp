import 'package:chat/api.dart';
import 'package:chat/components/primary_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/User.dart';
import 'package:chat/screens/auth/components/primaryField.dart';
import 'package:chat/screens/auth/login.dart';
import 'package:flutter/material.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({Key? key}) : super(key: key);

  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  final phoneController = TextEditingController(text: '');
  final nameController = TextEditingController(text: '');
  final passController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Image.asset(
                !isDark
                    ? "assets/images/Logo_light.png"
                    : "assets/images/Logo_dark.png",
                height: 146,
                width: double.infinity,
              ),
              SizedBox(
                height: kDefaultPadding * 3,
              ),
              Text(
                "Sign up",
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
                hint: 'Username',
                controller: nameController,
              ),
              SizedBox(
                height: kDefaultPadding,
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
                text: "Sign up",
                press: () async {
                  final user = User(
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      password: passController.text.trim());
                  API(context).signUpUser(user.toJson());
                },
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have account ?",
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
                    onTap: () => goTo(context, LoginScreen()),
                    child: Text(
                      "Sign in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: kDefaultPadding * 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
