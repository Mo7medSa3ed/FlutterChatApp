import 'package:chat/api.dart';
import 'package:chat/components/primary_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/User.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/auth/components/primaryField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditBody extends StatefulWidget {
  @override
  _EditBodyState createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
  final phoneController = TextEditingController(text: '');

  final nameController = TextEditingController(text: '');

  final passController = TextEditingController(text: '');
  final formKey = GlobalKey<FormState>();

  XFile? picked;

  @override
  void initState() {
    final user = Provider.of<AppProvider>(context, listen: false).user;
    phoneController.text = user!.phone ?? '';
    nameController.text = user.name ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppProvider, User>(
      selector: (ctx, appProvider) => appProvider.user!,
      builder: (ctx, user, w) => Container(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding + 10),
        child: Center(
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: kDefaultPadding,
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(user.img ?? img))),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                              iconSize: kDefaultPadding * 2,
                              onPressed: () async {
                                picked = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) async {
                                  if (value != null) {
                                   await API(context)
                                        .changeUserImage(value, user.id);
                                  }
                                  return null;
                                });
                                setState(() {});
                              },
                              icon: Icon(Icons.camera_alt)),
                        )),
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding * 4,
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
                  height: kDefaultPadding * 3,
                ),
                PrimaryButton(
                  text: "Edit Profile",
                  press: () async {
                    if (formKey.currentState!.validate()) {
                      User updatedUser = User(
                          id: user.id,
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          password: passController.text.trim());
                      await API(context).editUser(updatedUser);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
