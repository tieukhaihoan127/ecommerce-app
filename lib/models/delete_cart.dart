class DeleteCartModel {
  String? sessionId;
  String? tokenId;
  String? color;

  DeleteCartModel({
    this.sessionId,
    this.tokenId,
    this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId,
      "tokenId": tokenId,
      "color": color,
    };
  }

}