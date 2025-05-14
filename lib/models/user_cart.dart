class UserCartModel {
  String? sessionId;
  String? tokenId;

  UserCartModel({
    this.sessionId,
    this.tokenId
  });

  @override
  String toString() {
    return 'UserCartModel(sessionId: $sessionId,tokenId: $tokenId)';
  }

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId,
      "tokenId": tokenId
    };
  }

}