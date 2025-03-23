import 'package:ecommerce_app/models/change_password.dart';
import 'package:ecommerce_app/models/update_user_info.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/user_login.dart';
import 'package:ecommerce_app/services/user_service.dart';

class UserRepository {

  final UserService _userService = UserService();

  Future<void> addUser(UserModel user) => _userService.createUser(user);

  Future<dynamic> updateUser(UpdateUserInfo user, String id) => _userService.updateUser(user, id);

  Future<dynamic> getUserLogin(LoginUser user) => _userService.loginUser(user);

  Future<String> changeUserPassword(ChangePasswordInfo user, String id) => _userService.changeUserPassword(user, id);

}