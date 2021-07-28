import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:chat/models/room.dart';
import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  User? user;
  List<ChatMessage> chatList = [];
  List<Room> roomList = [];
  bool haRoom = false;
  bool search = false;

  changeSearch({val}) {
    if (val != null) {
      search = val;
    } else {
      search = !search;
    }
    notifyListeners();
  }

  initUser(user) {
    this.user = user;
    notifyListeners();
  }

  initRoomList(rooms) {
    this.roomList = rooms;
    
    notifyListeners();
  }

  initChatList(List<ChatMessage> chats) {
    chatList.clear();
    chatList.addAll(chats);
    notifyListeners();
  }

  addMsgTochat(ChatMessage chat) {
    chatList.add(chat);
    notifyListeners();
  }

  getChatList() => List<ChatMessage>.from(chatList.reversed);
}
