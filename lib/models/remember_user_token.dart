class RememberUserToken {
  
  final String token;
  final String newPassword;
  final String confirmPassword;

  RememberUserToken({
    required this.token,
    required this.newPassword,
    required this.confirmPassword
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "password": newPassword,
      "confirmPassword": confirmPassword
    };
  }

}