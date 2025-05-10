class AddCouponModel {
  String? code;
  int? discount;
  int? stock;

  AddCouponModel({
    this.code,
    this.discount,
    this.stock
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "discount": discount,
      "stock": stock
    };
  }

}