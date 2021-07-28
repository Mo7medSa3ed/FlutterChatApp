enum ChatMessageType { text, audio, image, video }
enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  String? text;
  ChatMessageType? messageType;
  MessageStatus? messageStatus;
  bool isSender;
  String? id;
  String? roomId;
  String? senderTo;
  String? createdAt;

  ChatMessage({
    this.createdAt,
    this.id,
    this.roomId,
    this.senderTo,
    this.text = '',
    this.messageType,
    this.messageStatus,
    this.isSender = false,
  });

  factory ChatMessage.fromJson(json, sender) => ChatMessage(
      text: json['text'],
      id: json['_id'],
      roomId: json['roomId'],
      senderTo: json['senderTo'],
      createdAt: json['ceatedAt'],
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
      isSender: sender);
}

// List demeChatMessages = [
//   ChatMessage(
//     text: "Hi Sajol,",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.viewed,
//     isSender: false,
//   ),
//   ChatMessage(
//     text: "Hello, How are you?",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.viewed,
//     isSender: true,
//   ),
//   ChatMessage(
//     text: "",
//     messageType: ChatMessageType.audio,
//     messageStatus: MessageStatus.viewed,
//     isSender: false,
//   ),
//   ChatMessage(
//     text: "",
//     messageType: ChatMessageType.video,
//     messageStatus: MessageStatus.viewed,
//     isSender: true,
//   ),
//   ChatMessage(
//     text: "Error happend",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.not_sent,
//     isSender: true,
//   ),
//   ChatMessage(
//     text: "This looks great man!!",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.viewed,
//     isSender: false,
//   ),
//   ChatMessage(
//     text: "Glad you like it",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.not_view,
//     isSender: true,
//   ),
// ];
