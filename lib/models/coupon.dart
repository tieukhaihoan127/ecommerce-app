class CouponModel {
  
  final int? discount;
  final String? code;
  final int? stock;

  CouponModel({
    this.discount,
    this.code,
    this.stock
  });

  @override
  String toString() {
    return 'Coupon(discount: $discount,code: $code, stock: $stock)';
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      discount:  json['discount'] ?? 0,
      code: json['code'] ?? '',
      stock:  json['stock'] ?? 0,
    );
  }


}