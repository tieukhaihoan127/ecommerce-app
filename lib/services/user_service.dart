import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/user.dart';

class UserService {

  final Dio _dio = Dio();

  Future<void> createUser(UserModel user) async {
  try {
    print("Request body: ${user.toJson()}"); 
    Response response = await _dio.post(
      ApiConfig.registerUrl, 
      data: user.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}) 
    );

    print("Server Response: ${response.data}");
  } on DioException catch (e) {
    print("Dio Error: ${e.response?.data}"); // Xem lỗi từ server
    rethrow;
  }
}



}