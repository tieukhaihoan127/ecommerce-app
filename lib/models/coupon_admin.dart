class CouponAdminModel {
  
  final String? id;
  final int? discount;
  final String? code;
  final String? description;
  final int? stock;
  final int? numberUsed;

  CouponAdminModel({
    this.id,
    this.discount,
    this.code,
    this.description,
    this.stock,
    this.numberUsed
  });

  @override
  String toString() {
    return 'Coupon(discount: $discount,code: $code, description: $description, stock: $stock, numberUsed: $numberUsed)';
  }

  factory CouponAdminModel.fromJson(Map<String, dynamic> json) {
    return CouponAdminModel(
      id: json['_id'] ?? '',
      discount:  json['discount'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      stock:  json['stock'] ?? 0,
      numberUsed:  json['numberUsed'] ?? 0,
    );
  }


}