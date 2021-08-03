enum ChatMessageType { text, audio, image, video, document, record }
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
  String? attachLink;

  ChatMessage({
    this.createdAt,
    this.id,
    this.roomId,
    this.senderTo,
    this.text = '',
    this.attachLink,
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
      attachLink: json['attachLink'],
      messageType: msgTypeReturn(json['type']),
      messageStatus: MessageStatus.viewed,
      isSender: sender);
}

msgTypeReturn(type) {
  if (type == 'text') {
    return ChatMessageType.text;
  } else if (type == 'record') {
    return ChatMessageType.record;
  } else if (type == 'image') {
    return ChatMessageType.image;
  } else if (type == 'document') {
    return ChatMessageType.document;
  } else if (type == 'video') {
    return ChatMessageType.video;
  } else {
    return ChatMessageType.audio;
  }
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
