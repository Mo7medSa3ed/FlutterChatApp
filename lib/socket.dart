import 'package:socket_io_client/socket_io_client.dart';

class Socket {
  final socket = io('http://10.0.2.2:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  emitOnline(data) {
    socket.emit('onlineUser', data);
  }

  emitDisonline(data) {
    socket.emit('disonlineUser', data);
  }

  emitChangeStatus(data) {
    socket.emit('changeStatus', data);
  }
}
