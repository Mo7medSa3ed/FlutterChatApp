import 'dart:convert';
import 'package:chat/Alert.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:chat/models/room.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:chat/socket.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class API {
  API(this.context);
  final context;
  final baseURL = 'http://10.0.2.2:3000';

  // login User

  loginUser(user) {
    try {
      showLoading(context);
      FocusScope.of(context).requestFocus(new FocusNode());
      final dio = new Dio();

      dio
          .post(
        '$baseURL/users/login',
        data: user,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            followRedirects: false,
            receiveDataWhenStatusError: true,
            responseType: ResponseType.json),
      )
          .then((res) async {
        if ([200, 201].contains(res.statusCode)) {
          final provider = Provider.of<AppProvider>(context, listen: false);
          provider.initUser(User.fromJson(res.data));
          setValue('user', jsonEncode(res.data));
          if (!Socket().socket.connected) {
            Socket().socket.connect();
          }
          Socket().emitOnline(res.data['_id']);
          await getAllChats(res.data['_id']);
          goToWithRemoveUntill(context, ChatsScreen());
        } else {
          Navigator.of(context).pop();
          return Alert.errorAlert(ctx: context);
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      }).catchError((e) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      });
    } catch (e) {
      Navigator.of(context).pop();
      return Alert.errorAlert(ctx: context);
    }
  }

  /*
   * get on user
   */
  Future<dynamic>? getUser(id) async {
    try {
      final dio = new Dio();
      final res = await dio.get(
        '$baseURL/users/$id',
      );
      if ([200, 201].contains(res.statusCode)) {
        return User.fromJson(res.data);
      } else {
        return 'error';
      }
    } catch (e) {
      return Future.value('error');
    }
  }

  // Signup User

  signUpUser(user) {
    try {
      showLoading(context);
      FocusScope.of(context).requestFocus(new FocusNode());

      new Dio()
          .post('$baseURL/users/',
              data: user,
              options: Options(contentType: Headers.formUrlEncodedContentType))
          .then((res) async {
        if ([200, 201].contains(res.statusCode)) {
          final provider = Provider.of<AppProvider>(context, listen: false);
          provider.initUser(User.fromJson(res.data));
          setValue('user', jsonEncode(res.data));
          if (!Socket().socket.connected) {
            Socket().socket.connect();
          }
          Socket().emitOnline(res.data['_id']);

          await getAllChats(res.data['_id']);
          goToWithRemoveUntill(context, ChatsScreen());
        } else {
          Navigator.of(context).pop();
          return Alert.errorAlert(ctx: context);
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      }).catchError((e) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      });
    } catch (e) {
      Navigator.of(context).pop();

      return Alert.errorAlert(ctx: context);
    }
  }

  // Edit Profile

  editUser(User user) {
    try {
      showLoading(context);
      FocusScope.of(context).requestFocus(new FocusNode());

      new Dio()
          .patch('$baseURL/users/${user.id}',
              data: user.toJson(),
              options: Options(contentType: Headers.formUrlEncodedContentType))
          .then((res) {
        if ([200, 201].contains(res.statusCode)) {
          final provider = Provider.of<AppProvider>(context, listen: false);
          provider.initUser(User.fromJson(res.data));
          setValue('user', jsonEncode(res.data));
          if (!Socket().socket.connected) {
            Socket().socket.connect();
          }
          Socket().emitOnline(res.data['_id']);
          Navigator.of(context).pop();
          Alert.sucessAlert(
              ctx: context,
              text: 'Update Profile Successfully',
              title: 'Update Profile',
              ontap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
        } else {
          Navigator.of(context).pop();
          return Alert.errorAlert(ctx: context);
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      }).catchError((e) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      });
    } catch (e) {
      Navigator.of(context).pop();

      return Alert.errorAlert(ctx: context);
    }
  }

  changeUserImage(XFile file, id) async {
    try {
      showLoading(context);

      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(file.path,
            filename: '${file.name.split('/').last}')
      });
      new Dio()
          .post(
        "$baseURL/users/upload/$id",
        data: formData,
      )
          .then((res) {
        if ([200, 201].contains(res.statusCode)) {
          final provider = Provider.of<AppProvider>(context, listen: false);
          provider.initUser(User.fromJson(res.data));
          setValue('user', jsonEncode(res.data));
          if (!Socket().socket.connected) {
            Socket().socket.connect();
          }
          Socket().emitOnline(res.data['_id']);
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          return Alert.errorAlert(ctx: context);
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      }).catchError((e) {
        Navigator.of(context).pop();
        return Alert.errorAlert(ctx: context);
      });
    } catch (e) {
      Navigator.of(context).pop();

      return Alert.errorAlert(ctx: context);
    }
  }

  Future<dynamic>? getAllChats(userId) async {
    try {
      final dio = new Dio();
      final res = await dio.get('$baseURL/rooms/$userId',
          options: Options(responseType: ResponseType.json));
      if ([200, 201].contains(res.statusCode)) {
        final data = List<Room>.from(res.data.map<Room>((e) {
          return Room.fromJson(e);
        }));
        Provider.of<AppProvider>(context, listen: false).initRoomList(data);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      return Future.value(null);
    }
  }

  Future<dynamic>? searchPeople(query) async {
    try {
      final uid = Provider.of<AppProvider>(context, listen: false).user!.id;

      final dio = new Dio();
      final res = await dio.get('$baseURL/users/search/$query',
          options: Options(responseType: ResponseType.json));
      if ([200, 201].contains(res.statusCode)) {
        final data = List<User>.from(res.data.map<User>((e) {
          return User.fromJson(e);
        }));
        final idx = data.indexWhere((e) => e.id == uid);
        if (idx != -1) data.removeAt(idx);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return Future.value(null);
    }
  }

  Future<dynamic>? getAllMessages(roomId, page) async {
    final uid = Provider.of<AppProvider>(context, listen: false).user!.id;
    try {
      final dio = new Dio();
      final res = await dio.get('$baseURL/messages/$roomId/$page',
          options: Options(responseType: ResponseType.json));
      if ([200, 201].contains(res.statusCode)) {
        List<ChatMessage> data = res.data
            .map<ChatMessage>(
                (e) => ChatMessage.fromJson(e, e['senderTo'] != uid))
            .toList();
        if (page == 1)
          Provider.of<AppProvider>(context, listen: false).chatList.clear();
        Provider.of<AppProvider>(context, listen: false).initChatList(data);
        if (data.length < 20) {
          return true;
        }
        return false;
      } else {
        return null;
      }
    } catch (e) {
      return Future.value(null);
    }
  }

  Future<dynamic>? sendMsg(msg) async {
    final uid = Provider.of<AppProvider>(context, listen: false).user!.id;
    try {
      final dio = new Dio();

      final res = await dio.post('$baseURL/messages/$uid',
          data: msg, options: Options(responseType: ResponseType.json));

      if ([200, 201].contains(res.statusCode)) {
        ChatMessage data = ChatMessage.fromJson(res.data, true);
        Provider.of<AppProvider>(context, listen: false).addMsgTochat(data);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<dynamic>? deleteAccount() async {
    showLoading(context);
    final uid = Provider.of<AppProvider>(context, listen: false).user!.id;
    try {
      final dio = new Dio();

      final res = await dio.delete('$baseURL/users/$uid',
          options: Options(responseType: ResponseType.json));

      if ([200, 201].contains(res.statusCode)) {
        if (res.data['success']) {
          clearPrfs();
          goToWithRemoveUntill(context, SigninOrSignupScreen());
        }
      } else {
        return false;
      }
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<dynamic>? deleteChat(id) async {
    final pro = Provider.of<AppProvider>(context, listen: false);
    showLoading(context);
    try {
      final dio = new Dio();

      final res = await dio.delete('$baseURL/rooms/$id',
          options: Options(responseType: ResponseType.json));

      if ([200, 201].contains(res.statusCode)) {
        print(res.data);
        if (res.data['success']) {
          pro.deleteRoom(id);
          Navigator.of(context).pop();
          return res.data['success'];
        }
      } else {
        return false;
      }
    } catch (e) {
      return Future.value(false);
    }
  }
}
