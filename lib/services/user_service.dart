import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/user_login.dart';

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
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    }
  }

  Future<dynamic> loginUser(LoginUser user) async {
    try {
      print("Request body: ${user.toJson()}"); 
      Response response = await _dio.post(
        ApiConfig.loginUrl, 
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      print("Server Response: ${response.data}");

      if (response.data['token'] == null) {
        return await Future.error("Lỗi hệ thống, không nhận được token!");
      }

      if (response.data != null) {
        return response.data;
      } else {
        return await Future.error("Lỗi hệ thống, không nhận được data!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Đăng nhập thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    }
  }



}