class AddReviewModel {
  String? productId;
  String? message;

  AddReviewModel({
    this.productId,
    this.message
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "comment": message
    };
  }

}