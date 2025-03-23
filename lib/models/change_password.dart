class ChangePasswordInfo {
  
  final String? currentPassword;
  final String? newPassword;
  final String? confirmPassword;

  ChangePasswordInfo({
    this.currentPassword,
    this.newPassword,
    this.confirmPassword
  });


  Map<String, dynamic> toJson() {
    return {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword
    };
  }

}