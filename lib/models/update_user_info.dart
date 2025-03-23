class UpdateUserInfo {
  
  final String? email;
  final String? fullName;
  final String? imageUrl;

  UpdateUserInfo({
    this.email,
    this.fullName,
    this.imageUrl
  });

  factory UpdateUserInfo.fromJson(Map<String, dynamic> json) {
    return UpdateUserInfo(
      email:  json['email'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "fullName": fullName,
      "imageUrl": imageUrl
    };
  }

}