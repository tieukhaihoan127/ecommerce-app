import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';

class ChatService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchMessages(String userId) async {
    final response = await _dio.post(
      ApiConfig.chatUrl,
      data: { "user": userId },
      options: Options(headers: {'Content-Type': 'application/json'}) 
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data["chats"]);
    }
    throw Exception("Failed to fetch messages");
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await _dio.get(ApiConfig.chatUsersUrl);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data["users"]);
    }
    throw Exception("Failed to fetch messages");
  }
}
