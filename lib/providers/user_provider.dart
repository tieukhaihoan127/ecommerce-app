import 'package:ecommerce_app/models/change_password.dart';
import 'package:ecommerce_app/models/otp_verify.dart';
import 'package:ecommerce_app/models/remember_user_token.dart';
import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:ecommerce_app/models/update_user_info.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/user_login.dart';
import 'package:ecommerce_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {

  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  UserModel? _user;

  UserModel? get user => _user;

  String _token = "";

  String get token => _token;

  Future<void> addUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userRepository.addUser(user);
      _errorMessage = '';
    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(UpdateUserInfo user, String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.updateUser(user, id);
      if(response != "") {

        bool updated = false;

        if(response["email"] != "") {
          _user?.email = response["email"];
          updated = true;
        }

        if(response["fullName"] != "") {
          _user?.fullName = response["fullName"];
          updated = true;
        }

        if(response["imageUrl"] != "") {
          _user?.imageUrl = response["imageUrl"];
          updated = true;
        }

        _errorMessage = '';
        if(updated) notifyListeners();
      } else {
        _errorMessage = "Cập nhật thông tin thất bại!";
        notifyListeners();
      }

    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> changeUserPassword(ChangePasswordInfo user, String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.changeUserPassword(user, id);
      if(response != "") {

        // bool updated = false;

        _errorMessage = '';
        notifyListeners();
        return response;
      } else {
        _errorMessage = "Đổi mật khẩu thất bại!";
        notifyListeners();
      }

    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

    return "";
  }

  Future<bool> loginUser(LoginUser user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.getUserLogin(user);
      if (response != "") {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response["token"]);
        _user = UserModel(
          id: response["id"],
          email: response["email"],
          fullName: response["fullName"],
          imageUrl: response["imageUrl"],
          shippingAddress: ShippingAddress.fromJson(response["shippingAddress"])
        );

        _errorMessage = "";
        notifyListeners();
        return true; 
      } else {
        _errorMessage = "Đăng nhập thất bại!";
        notifyListeners();
        return false; 
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getAccountOTP(dynamic email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.getOTPAccount(email);
      if(response != "") {

        if(response["message"] != "") {
          return response["message"];
        }

        _errorMessage = '';
        notifyListeners();
      } else {
        _errorMessage = "Gửi mã OTP thất bại!";
        notifyListeners();
      }

    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

    return "Gửi mã OTP không thành công!";
  }

  Future<String> submitAccountOTPPost(OTPVerify userInfo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.submitOTP(userInfo);
      if(response != "") {

        if(response["token"] != "") {
          _token = response["token"];
        }

        if(response["message"] != "") {
          return response["message"];
        }

        _errorMessage = '';
        notifyListeners();
      } else {
        _errorMessage = "Gửi mã OTP thất bại!";
        notifyListeners();
      }

    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

    return "Xác nhận mã OTP không thành công!";
  }

  Future<String> updatePasswordPost(RememberUserToken userInfo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.updatePassword(userInfo);
      if(response != "") {

        _errorMessage = '';
        notifyListeners();
        return response;

      } else {
        _errorMessage = "Cập nhật mật khẩu thất bại!";
        notifyListeners();
      }

    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

    return "Cập nhật mật khẩu không thành công!";
  }

  Future<void> resetUser() async {
      _user = null;
      notifyListeners();
  }

}