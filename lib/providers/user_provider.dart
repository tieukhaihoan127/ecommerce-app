import 'package:ecommerce_app/models/change_password.dart';
import 'package:ecommerce_app/models/otp_verify.dart';
import 'package:ecommerce_app/models/remember_user_token.dart';
import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:ecommerce_app/models/update_user_info.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/user_admin_model.dart';
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

  List<UserAdminModel>? _userAdmin;

  List<UserAdminModel>? get userAdmin => _userAdmin;

  UserAdminModel? _userAdminDetail;

  UserAdminModel? get userAdminDetail => _userAdminDetail;

  Future<void> getUserById() async {
    
    try {
      final prefs = await SharedPreferences.getInstance();
      String? tokenId = prefs.getString('token');

      final response = await _userRepository.getUserById(tokenId!);
      print("Response Data: $response");

      if(response != null) {
        _user = UserModel(
          id: response["id"],
          email: response["email"],
          fullName: response["fullName"],
          imageUrl: response["imageUrl"],
          shippingAddress: ShippingAddress.fromJson(response["shippingAddress"]),
          isAdmin: response["isAdmin"]
        );

        _errorMessage = "";
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }

  }

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

  Future<void> updateAddress(String city, String district, String ward, String shipping, String id) async {

    try {

      var address = ShippingAddress(city: city, district: district, ward: ward, address: shipping);

      final response = await _userRepository.updateAddress(address, id);
      if(response != "") {

        _user?.shippingAddress?.city = city;
        _user?.shippingAddress?.district = district;
        _user?.shippingAddress?.ward = ward;
        _user?.shippingAddress?.address = shipping;

        _errorMessage = '';
        notifyListeners();
      } else {
        _errorMessage = "Cập nhật thông tin thất bại!";
        notifyListeners();
      }

    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }
  }

  Future<String> changeUserPassword(ChangePasswordInfo user, String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.changeUserPassword(user, id);
      if(response != "") {

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
      print("Response Data: $response");
      if (response != "") {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response["token"]);
        _user = UserModel(
          id: response["id"],
          email: response["email"],
          fullName: response["fullName"],
          imageUrl: response["imageUrl"],
          shippingAddress: ShippingAddress.fromJson(response["shippingAddress"]),
          isAdmin: response["isAdmin"]
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

  Future<void> loadUserAdmin() async {
    _isLoading = true;
    notifyListeners();

    try { 
      final users = await _userRepository.getAllUsersAdmin();
      if(users.isNotEmpty) {
        _userAdmin = (users as List).map<UserAdminModel>((item) => UserAdminModel.fromJson(item)).toList();
      }

      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserAdminDetail(String userId) async {
    _isLoading = true;
    notifyListeners();

    try { 
      final user = await _userRepository.getUserAdminDetail(userId);
      
      _userAdminDetail = UserAdminModel.fromJson(user);

      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> updateUserAdminInfo(String id, String email, String fullName, String city, String district, String ward, String address, String status) async {
    _isLoading = true;
    notifyListeners();

    try {

      var shippingAddress = ShippingAddress(city: city, district: district, ward: ward, address: address);

      var user = UserAdminModel(email: email, fullName: fullName, shippingAddress: shippingAddress,status: status); 

      final response = await _userRepository.updateUserAdmin(user, id);
      if(response != "") {
        _errorMessage = '';
        loadUserAdmin();
        notifyListeners();
        return response;
      } else {
        _errorMessage = "Cập nhật thông tin người dùng thất bại!";
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

  Future<void> resetUser() async {
      _user = null;
      notifyListeners();
  }

}