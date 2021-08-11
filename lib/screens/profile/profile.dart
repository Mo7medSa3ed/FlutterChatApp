import 'package:chat/api.dart';
import 'package:chat/components/primary_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/User.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/profile/components/profileItem.dart';
import 'package:chat/screens/profile/editProfilescrean.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<AppProvider, User>(
        selector: (ctx, appProvider) => appProvider.user!,
        builder: (context, user, child) => Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding + 10,
                  vertical: kDefaultPadding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(user.img ?? img))),
                  ),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  Text(
                    user.name ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Provider.of<AppProvider>(context).dark
                            ? kContentColorDarkTheme
                            : kContentColorLightTheme),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 2),
                    child: Divider(
                      thickness: 0.7,
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  ProfileItem(
                    title: "User ID",
                    value: '${user.id}',
                  ),
                  ProfileItem(
                    title: "Mobile",
                    value: '${user.phone}',
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                            text: 'Delete Account',
                            color: kErrorColor,
                            press: () async => API(context).deleteAccount()),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: PrimaryButton(
                            text: 'Edit Profile',
                            press: () => goTo(context, EditProfileScrean())),
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ));
  }
}
