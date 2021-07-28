import 'package:chat/models/User.dart';
import 'package:chat/models/message.dart';

class Room {
  List<Message>? messages;
  bool? isOpen;
  String? id;
  User? reciverId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  Message? lastMessage;

  Room(
      {this.createdAt,
      this.id,
      this.isOpen,
      this.lastMessage,
      this.messages,
      this.reciverId,
      this.updatedAt,
      this.userId});

  factory Room.fromJson(json) => Room(
        messages: List.from(
            json['messages'].map<Message>((e) => Message.fromJson(e)).toList()),
        isOpen: json['isOpen'],
        id: json['_id'],
        reciverId: User.fromJson(json['reciverId']),
        userId: json['userId'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        lastMessage: Message.fromJson(json['lastMessage']),
      );

  // Map<String, dynamic> toJson() => {
  //       'text': text,
  //       'senderId': senderId,
  //       'roomId': roomId,
  //     };

}
