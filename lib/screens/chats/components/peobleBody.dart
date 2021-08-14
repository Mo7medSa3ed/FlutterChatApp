import 'package:chat/api.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/User.dart';
import 'package:chat/provider/app_provider.dart' as ap;
import 'package:chat/screens/chats/components/user_card.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contacts_service/contacts_service.dart';

class PeopleBody extends StatefulWidget {
  @override
  _PeopleBodyState createState() => _PeopleBodyState();
}

class _PeopleBodyState extends State<PeopleBody> {
  List<User>? users = [];
  bool isFirst = true;
  final searchControoler = TextEditingController(text: '');
  List contactsNumbers = [];
  @override
  void initState() {
    getContacts();
    super.initState();
  }

  getContacts() async {
    final contacts = await ContactsService.getContacts(withThumbnails: false);
    contacts.forEach((e) {
      if (e.phones != null)
        e.phones!.toSet().forEach((v) {
          contactsNumbers.add(v.value!.replaceAll("+2", ""));
        });
    });
  }

  search(query) async {
    users = await API(context).searchPeople(query);
    final res =
        (users ?? []).where((e) => contactsNumbers.contains(e.phone)).toList();
    users!
      ..clear()
      ..addAll(res);
    isFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5)),
            child: TextField(
              controller: searchControoler,
              maxLength: 20,
              onChanged: (String val) async {
                if (val.trim().length ==11) {
                  await search(val.trim().toLowerCase());
                } else {
                  users = [];
                  isFirst = true;
                }
                setState(() {});
              },
              cursorColor: Theme.of(context).textTheme.bodyText1!.color!,
              maxLines: 1,
              decoration: InputDecoration(
                counterText: '',
                hintText: "Search here...",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: users!.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: users?.length,
                  itemBuilder: (context, index) => UserCard(
                    user: users![index],
                    press: () {
                      final provider =
                          Provider.of<ap.AppProvider>(context, listen: false);
                      var rid;
                      (provider.roomList ?? []).forEach((e) {
                        if (e.reciverId!.id == users![index].id) {
                          rid = e.id;
                          return;
                        }
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MessagesScreen(users![index], rid),
                        ),
                      ).then((value) {
                        setState(() {
                          searchControoler.clear();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          users!.clear();
                          isFirst = true;
                        });
                      });
                    },
                  ),
                )
              : Center(
                  child: (isFirst && users!.length == 0)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 3),
                          child: Text(
                            "Hi you can search for user with phone to chat with them.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, letterSpacing: 2),
                          ),
                        )
                      : CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                ),
        ),
      ],
    );
  }
}
