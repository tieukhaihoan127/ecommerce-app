import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {

  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

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

}