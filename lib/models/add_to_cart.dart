class AddToCartModel {
  String? sessionId;
  String? tokenId;
  String? color;
  int? quantity;

  AddToCartModel({
    this.sessionId,
    this.tokenId,
    this.color,
    this.quantity
  });

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId,
      "tokenId": tokenId,
      "color": color,
      "quantity": quantity
    };
  }

}