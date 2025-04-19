class UserCartModel {
  String? sessionId;
  String? tokenId;

  UserCartModel({
    this.sessionId,
    this.tokenId
  });

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId,
      "tokenId": tokenId
    };
  }

}