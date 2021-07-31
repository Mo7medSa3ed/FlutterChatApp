class User {
  String? name;
  String? id;
  String? phone;
  String? password;
  String? img;
  String? createdAt;
  String? updatedAt;
  String? lastSeen;
  bool? online =false;

  User(
      {this.img,
      this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.password,
      this.lastSeen,
      this.online,
      this.phone});

  factory User.fromJson(json) => User(
        name: json['name'],
        id: json['_id'],
        phone: json['phone'],
        password: json['password'],
        img: json['img'],
        online: json['online'],
        createdAt: json['createdAt'],
        lastSeen: json['lastSeen'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'password': password,
      };
}
