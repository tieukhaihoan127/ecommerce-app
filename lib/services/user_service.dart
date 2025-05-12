import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/change_password.dart';
import 'package:ecommerce_app/models/otp_verify.dart';
import 'package:ecommerce_app/models/remember_user_token.dart';
import 'package:ecommerce_app/models/update_user_info.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/user_admin_model.dart';
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

  Future<dynamic> updateUser(UpdateUserInfo user, String id) async {
    try {
      final url = "${ApiConfig.updateUserUrl}${id}";
      Response response = await _dio.patch(
        url, 
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      print("Server Response: ${response.data}");

      if (response.data != null) {
        return response.data;
      } else {
        return await Future.error("Lỗi hệ thống, không nhận được data!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    }
  }

  Future<String> changeUserPassword(ChangePasswordInfo user, String id) async {
    try {

      final url = "${ApiConfig.changePasswordUrl}${id}";
      Response response = await _dio.patch(
        url, 
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      print("Server Response: ${response.data}");

      if (response.data != null && response.data["message"] != null) {
        return response.data["message"];
      } else {
        return await Future.error("Lỗi hệ thống, không nhận được data!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Đổi mật khẩu thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
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

  Future<dynamic> sendOTPToUser(dynamic email) async {

    try {
      
      Response response = await _dio.post(
        ApiConfig.getOTPUrl,
        data: email,
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      print("Server Response: ${response.data}");

      if (response.data != null) {
        return response.data;
      } else {
        return await Future.error("Lỗi hệ thống, không nhận được OTP!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Gửi mã OTP thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    }

  }

  Future<dynamic> submitUserOTP(OTPVerify info) async {

    try {
      
      Response response = await _dio.post(
        ApiConfig.submitOTPUrl,
        data: info.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      print("Server Response: ${response.data}");

      if (response.data != null) {
        return response.data;
      } else {
        return await Future.error("Lỗi hệ thống, không xác nhận được OTP!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Xác nhận mã OTP thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    }

  }

  Future<String> userPasswordRecovery(RememberUserToken info) async {

    try {
      
      Response response = await _dio.post(
        ApiConfig.updatePasswordUrl,
        data: info.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      print("Server Response: ${response.data}");

      if (response.data != null && response.data["message"] != "") {
        return response.data["message"];
      } else {
        return await Future.error("Lỗi hệ thống, không thể cập nhật mật khẩu!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Cập nhật mật khẩu thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    }

  }

  Future<dynamic> getUserById(String tokenId) async {
    try {
      
      Response response = await _dio.post(
        ApiConfig.getUserUrl,
        data: {"tokenId": tokenId},
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      print("Server Response: ${response.data}");

      if (response.data != null && response.statusCode == 200) {
        return response.data;
      }
      else {
        return await Future.error("Lỗi hệ thống, không nhận được OTP!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Lấy thông tin người dùng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    }
  }

  Future<List<Map<String,dynamic>>> getUserAdmin() async{
    try {
      Response response = await _dio.get(ApiConfig.getUserAdminUrl);
      if (response.statusCode == 200 && response.data["user"].length > 0) {
        return List<Map<String, dynamic>>.from(response.data["user"]);
      }
      throw Exception('Failed to load user');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<Map<String,dynamic>> getUserAdminDetail(String userId) async{
    try {
      var url = "${ApiConfig.getUserAdminUrl}$userId";
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data["users"]);
      }
      throw Exception('Failed to load user detail');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<String> updateUserAdmin(UserAdminModel user, String id) async {
    try {
      final url = "${ApiConfig.updateUserAdminUrl}$id";
      Response response = await _dio.patch(
        url, 
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );

      if (response.data != null) {
        return response.data["message"];
      } else {
        return await Future.error("Lỗi hệ thống, không nhận được data!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    }
  }

}