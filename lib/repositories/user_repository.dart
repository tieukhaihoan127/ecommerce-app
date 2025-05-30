import 'package:ecommerce_app/models/change_password.dart';
import 'package:ecommerce_app/models/otp_verify.dart';
import 'package:ecommerce_app/models/remember_user_token.dart';
import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:ecommerce_app/models/update_user_info.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/user_admin_model.dart';
import 'package:ecommerce_app/models/user_login.dart';
import 'package:ecommerce_app/services/user_service.dart';

class UserRepository {

  final UserService _userService = UserService();

  Future<dynamic> getUserById(String tokenId) => _userService.getUserById(tokenId);
 
  Future<void> addUser(UserModel user) => _userService.createUser(user);

  Future<dynamic> updateUser(UpdateUserInfo user, String id) => _userService.updateUser(user, id);

  Future<dynamic> updateAddress(ShippingAddress address, String id) => _userService.updateAddress(address, id);

  Future<dynamic> getUserLogin(LoginUser user) => _userService.loginUser(user);

  Future<String> changeUserPassword(ChangePasswordInfo user, String id) => _userService.changeUserPassword(user, id);

  Future<dynamic> getOTPAccount(dynamic email) => _userService.sendOTPToUser(email);

  Future<dynamic> submitOTP(OTPVerify info) => _userService.submitUserOTP(info);

  Future<String> updatePassword(RememberUserToken info) => _userService.userPasswordRecovery(info);

  Future<List<Map<String,dynamic>>> getAllUsersAdmin() => _userService.getUserAdmin();

  Future<Map<String,dynamic>> getUserAdminDetail(String userId) => _userService.getUserAdminDetail(userId);

  Future<String> updateUserAdmin(UserAdminModel user, String id) => _userService.updateUserAdmin(user, id);

}