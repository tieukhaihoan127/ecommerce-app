class AddRatingModel {
  String? productId;
  String? tokenId;
  String? message;
  double? rating;

  AddRatingModel({
    this.productId,
    this.tokenId,
    this.message,
    this.rating
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "tokenId": tokenId,
      "comment": message,
      "star": rating
    };
  }

}