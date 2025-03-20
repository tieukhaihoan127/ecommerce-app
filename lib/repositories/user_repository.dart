import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/user_login.dart';
import 'package:ecommerce_app/services/user_service.dart';

class UserRepository {

  final UserService _userService = UserService();

  Future<void> addUser(UserModel user) => _userService.createUser(user);

  Future<dynamic> getUserLogin(LoginUser user) => _userService.loginUser(user);

}