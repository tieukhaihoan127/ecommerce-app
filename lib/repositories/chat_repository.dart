import 'package:ecommerce_app/services/chat_service.dart';

class ChatRepository {

  final ChatService _chatService = ChatService();

  Future<List<Map<String,dynamic>>> getAllMessages(String userId) => _chatService.fetchMessages(userId);

  Future<List<Map<String,dynamic>>> getAllUserMessages() => _chatService.fetchUsers();

}