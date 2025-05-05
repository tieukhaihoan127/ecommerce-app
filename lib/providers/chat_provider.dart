import 'package:ecommerce_app/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/chat_socket_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository _repository = ChatRepository();
  final ChatSocketService _socketService = ChatSocketService();

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void connectSocket(String userId) {
    _socketService.connect(userId);
  }

  void sendMessage(String token, String content, List<String> images) {
    _socketService.sendMessage(token, content, images);
  }

  void disconnectSocket() {
    _socketService.disconnect();
  }

  Future<void> loadMessages(String token) async {
    _isLoading = true;
    _messages = await _repository.getAllMessages(token);
    _isLoading = false;
    notifyListeners();
  }

  void addLocalMessage(Map<String, dynamic> message) {
    _messages.add(message);
    notifyListeners();
  }
}
