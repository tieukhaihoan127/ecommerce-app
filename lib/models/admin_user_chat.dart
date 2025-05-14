class AdminUserChatModel {
  
  final String? id;
  final String? fullName;
  final String? imageUrl;

  AdminUserChatModel({
    this.id,
    this.fullName,
    this.imageUrl
  });


  factory AdminUserChatModel.fromJson(Map<String, dynamic> json) {
    return AdminUserChatModel(
      id:  json['_id'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
    );
  }

}