import 'package:chat/models/User.dart';
import 'package:chat/models/message.dart';

class Room {
  List<Message>? messages;
  bool? isOpen;
  String? id;
  User? reciverId;
  User? userId;
  String? createdAt;
  String? updatedAt;
  Message? lastMessage;
  int? msgCount =-1;
  String? recieverStatus;

  Room(
      {this.createdAt,
      this.id,
      this.isOpen,
      this.lastMessage,
      this.messages,
      this.msgCount,
      this.reciverId,
      this.updatedAt,
      this.userId});

  factory Room.fromJson(json, {msgs = true, lastMsg, isOpen}) => Room(
        msgCount: json['messages'].length,
        messages: (json['messages'].length > 0 && msgs)
            ? List.from(json['messages']
                .map<Message>((e) => Message.fromJson(e))
                .toList())
            : [],
        isOpen: isOpen ?? json['isOpen'],
        id: json['_id'],
        reciverId: User.fromJson(json['reciverId']),
        userId: User.fromJson(json['userId']),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        lastMessage: Message.fromJson(msgs ? json['lastMessage'] : lastMsg),
      );

  // Map<String, dynamic> toJson() => {
  //       'text': text,
  //       'senderId': senderId,
  //       'roomId': roomId,
  //     };

}
