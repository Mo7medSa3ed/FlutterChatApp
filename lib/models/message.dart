class Message {
  String? text;
  String? id;
  String? roomId;
  String? senderTo;
  String? createdAt;
  bool? isRead;
  String? img;
  String? updatedAt;

  Message(
      {this.img,
      this.id,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.roomId,
      this.senderTo,
      this.text});

  factory Message.fromJson(json) => Message(
        text: json['text'],
        id: json['_id'],
        roomId: json['roomId'],
        isRead: json['isRead'],
        senderTo: json['senderTo'],
        img: json['img'],
        createdAt: json['ceatedAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'senderId': senderTo,
        'roomId': roomId,
      };
}
