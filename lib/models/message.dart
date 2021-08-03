class Message {
  String? text;
  String? id;
  String? roomId;
  String? senderTo;
  String? createdAt;
  bool? isRead;
  String? attachLink;
  String? type;
  String? updatedAt;

  Message(
      {this.attachLink,
      this.id,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.type,
      this.roomId,
      this.senderTo,
      this.text});

  factory Message.fromJson(json) => Message(
        text: json['text'],
        type: json['type'],
        id: json['_id'],
        roomId: json['roomId'],
        isRead: json['isRead'],
        senderTo: json['senderTo'],
        attachLink: json['attachLink'],
        createdAt: json['ceatedAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (attachLink != null) {
      map["attachLink"] = attachLink;
    }
    if (text != null) {
      map['text'] = text ?? '';
    }
    map['senderTo'] = senderTo;
    map['roomId'] = roomId;
    map['type'] = type;

    return map;
  }
}
