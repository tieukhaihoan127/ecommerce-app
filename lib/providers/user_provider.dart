import 'package:dio/dio.dart';
import 'package:ecommerce_app/models/shipping_address.dart';
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

  Future<bool> loginUser(LoginUser user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userRepository.getUserLogin(user);
      if (response != "") {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response["token"]);
        _user = UserModel(
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

  Future<void> resetUser() async {
      _user = null;
      notifyListeners();
  }

}