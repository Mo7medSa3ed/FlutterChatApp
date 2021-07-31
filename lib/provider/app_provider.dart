import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/room.dart';
import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  User? user;
  List<ChatMessage> chatList = [];
  List<Room>? roomList;
  bool haRoom = false;
  bool search = false;
  String? roomId;

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

  initRoomId(roomid) {
    this.roomId = roomid;
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

  changeUserStatus(data) {
    final idx = roomList!.indexWhere((e) => e.id == data['roomId']);
    if (idx != -1) {
      if (roomList![idx].isOpen ?? false) {
        if (roomList![idx].userId!.id == data['reciever'] ||
            roomList![idx].reciverId!.id == data['reciever']) {
          roomList![0].recieverStatus = data['status'];
          notifyListeners();
        }
      }
    }
  }

  changeUserStatusForRoom(User data) {
    (roomList ?? []).forEach((e) {
      if (e.reciverId!.id == data.id) {
        e.userId!.online = data.online;
      } else if (e.userId!.id == data.id) {
        e.reciverId!.online = data.online;
      }
    });
    notifyListeners();
  }

  addMsgTochat(ChatMessage chat) {
    bool read = false;
    if (chatList.length > 0) {
      read = (chat.roomId == chatList[0].roomId);
      if (read) {
        chatList.add(chat);
      }
    } else {
      chatList.add(chat);
    }
    final idx = roomList!.indexWhere((e) => e.id == chat.roomId);
    if (idx != -1) {
      roomList![idx].lastMessage = Message(
          createdAt: chat.createdAt,
          id: chat.id,
          roomId: chat.roomId,
          senderTo: chat.senderTo,
          isRead: roomList![idx].isOpen!,
          text: chat.text);

      if (!roomList![idx].isOpen!) {
        roomList![idx].msgCount = roomList![idx].msgCount! + 1;
      } else {
        roomList![idx].msgCount = 0;
      }
    }

    notifyListeners();
  }

  addRoom(Room room) {
    if (roomList!.length > 0) {
      if (roomList!.indexWhere((e) => e.id == room.id) == -1) {
        roomList!.add(room);
      }
    } else {
      roomList!.add(room);
    }
    notifyListeners();
  }

  getChatList() => List<ChatMessage>.from(chatList.reversed);
}
