class CouponModel {
  
  final int? discount;
  final String? code;
  final String? description;
  final int? stock;

  CouponModel({
    this.discount,
    this.code,
    this.description,
    this.stock
  });

  @override
  String toString() {
    return 'Coupon(discount: $discount,code: $code, description: $description, stock: $stock)';
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      discount:  json['discount'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      stock:  json['stock'] ?? 0,
    );
  }


}