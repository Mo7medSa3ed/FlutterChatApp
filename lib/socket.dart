import 'package:chat/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Socket {
  final socket = io('https://chatserver1235.herokuapp.com/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  emitOnline(data) {
    setBoolValue('online', true);
    socket.emit('onlineUser', data);
  }

  emitDisonline(data) {
    setBoolValue('online', false);
    socket.emit('disonlineUser', data);
  }

  emitChangeStatus(data) {
    socket.emit('changeStatus', data);
  }

  




}
