class ChatModel {
  String? senderId;
  String? receiverId;
  String? content;
  List<String>? images;
  String? infoUser;

  ChatModel({
    this.senderId,
    this.receiverId,
    this.content,
    this.images,
    this.infoUser
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      images: List<String>.from(json['images']) ?? [],
      infoUser: json['infoUser'] ?? '',
    );
  }

}