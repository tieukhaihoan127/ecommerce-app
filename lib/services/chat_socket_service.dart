import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  static final ChatSocketService _instance = ChatSocketService._internal();
  factory ChatSocketService() => _instance;
  ChatSocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;

  void connect(String userId) {
    if (_isConnected) return;

    _socket = IO.io(ApiConfig.baseUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());

    _socket!.connect();

    _socket!.onConnect((_) {
      _isConnected = true;
      _socket!.emit('JOIN_ROOM', userId);
    });
  }

  void sendMessage(String userId, String content, List<String> images) {
    if (_socket != null && _isConnected) {
      _socket!.emit("CLIENT_SEND_MESSAGE", {
        "userId": userId,
        "content": content,
        "images": images,
      });
    }
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    _socket?.off("SERVER_RECEIVE_MESSAGE");
    _socket?.on("SERVER_RECEIVE_MESSAGE", (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  void disconnect() {
    if (_socket != null && _isConnected) {
      _socket!.disconnect();
      _socket!.destroy(); 
      _isConnected = false;
      _socket = null;
    }
  }
}
