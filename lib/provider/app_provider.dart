import 'package:chat/constants.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/room.dart';
import 'package:chat/notification.dart';
import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  User? user;
  List<ChatMessage> chatList = [];
  List<Room>? roomList;
  bool haRoom = false;
  bool search = false;
  bool pressed = false;
  bool dark = false;
  String? roomId;

  changeSearch({val}) {
    if (val != null) {
      search = val;
    } else {
      search = !search;
    }
    pressed = false;
    notifyListeners();
  }

  initUser(user) {
    this.user = user;
    setBoolValue('online', user.online);
    notifyListeners();
  }

  changeDark(dark) {
    this.dark = dark;
    setBoolValue('dark', dark);
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
    chatList.addAll(chats);
    notifyListeners();
  }

  clearChatList() {
    chatList.clear();
    notifyListeners();
  }

  changeUserStatus(data) {
    final idx = roomList!.indexWhere((e) => e.id == data['roomId']);
    if (idx != -1) {
      if (user!.id == data['reciever']) {
        roomList![idx].recieverStatus = data['status'];
        notifyListeners();
      }
    }
  }

  changeUserImage(user) {
    roomList!.forEach((e) {
      if (e.reciverId!.id == user!.id) {
        e.reciverId = user;
      }
    });
    notifyListeners();
  }

  changeUserStatusForRoom(User data) {
    (roomList ?? []).forEach((e) {
      if (e.reciverId!.id == data.id) {
        e.reciverId!.online = data.online;
      } else if (e.userId!.id == data.id) {
        e.userId!.online = data.online;
      }
    });
    notifyListeners();
  }

  addMsgTochat(ChatMessage chat) async {
    bool read = false;
    final idx = roomList!.indexWhere((e) => e.id == chat.roomId);
    if (idx != -1) {
      roomList![idx].lastMessage = Message(
          createdAt: chat.createdAt,
          id: chat.id,
          roomId: chat.roomId,
          senderTo: chat.senderTo,
          isRead: roomList![idx].isOpen!,
          text: chat.text);

      final bool open = roomList![idx].open!;
      chat.messageStatus = open ? MessageStatus.viewed : MessageStatus.not_view;
      if (open == false) {
        saveMsgIdForPrfs(chat.id);
      }
      if (chatList.length > 0) {
        read = (chat.roomId == chatList[0].roomId);
        if (read) {
          chatList.insert(0, chat);
        }
      } else {
        chatList.insert(0, chat);
      }
      if (roomList![idx].isOpen!) {
        roomList![idx].msgCount = 0;
      } else {
        if (chatList.length == 1 && roomList![idx].msgCount! < 1) {
          roomList![idx].msgCount = 1;
        } else {
          roomList![idx].msgCount = roomList![idx].msgCount! + 1;
        }
        if (roomList![idx].reciverId!.id == user!.id) {
          await notificationPlugin.showNotification(
              chatList.length,
              roomList![idx].userId!.name,
              chat.text ?? chat.attachLink,
              chat.roomId);
        } else {
          await notificationPlugin.showNotification(
              chatList.length,
              roomList![idx].reciverId!.name,
              chat.text ?? chat.attachLink,
              chat.roomId);
        }
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

  deleteRoom(id) {
    if (roomList!.length > 0) {
      int index = roomList!.indexWhere((e) => e.id == id);
      if (index != -1) {
        roomList!.removeAt(index);
        notifyListeners();
      }
    }
  }

  changStatusForMessages(data) async {
    roomList!.firstWhere((e) => e.id == data['id']).open = data['open'];
    print(data);
    var unredList = [];
    if (chatList.length > 0) {
      if (chatList[0].roomId == data['id']) {
        chatList.forEach((e) {
          if (data['open']) {
            if (e.messageStatus == MessageStatus.not_view) {
              unredList.add(e.id);
              e.messageStatus = MessageStatus.viewed;
            }
          }
        });
        await removeMsgIdForPrfs(unredList);
      }
    }
    notifyListeners();
  }

  getChatList() => [...chatList];
}
