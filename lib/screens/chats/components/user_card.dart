import 'package:chat/models/User.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.user,
    required this.press,
  }) : super(key: key);

  final User user;
  final press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(user.img ?? img),
                ),
                // if (user.online ?? false)
                //   Positioned(
                //     right: 0,
                //     bottom: 0,
                //     child: Container(
                //       height: 16,
                //       width: 16,
                //       decoration: BoxDecoration(
                //         color: kPrimaryColor,
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //             color: Theme.of(context).scaffoldBackgroundColor,
                //             width: 3),
                //       ),
                //     ),
                //   )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? '',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    // SizedBox(height: 4),
                    // Opacity(
                    //   opacity: 0.6,
                    //   child: Text(
                    //     user.phone ?? '',
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Opacity(opacity: 0.64, child: Text(dateTimeFormat(user.lastSeen))),
          ],
        ),
      ),
    );
  }
}
