import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final title, value;
  const ProfileItem({Key? key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding * 2 - 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.6)),
          ),
          Expanded(
            child: Text(
              "$value",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.bodyText1!.color!),
            ),
          ),
        ],
      ),
    );
  }
}
