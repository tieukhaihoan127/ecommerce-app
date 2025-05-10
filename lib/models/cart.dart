import 'package:ecommerce_app/models/product_cart.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CartModel {
  String? id;
  String? productId;
  String? color;
  int? quantity;
  ProductCart? carts;
  int? totalPrice;
  int? taxes;
  int? shippingFee;
  double? loyaltyPoint;

  CartModel({
    this.id,
    this.productId,
    this.color,
    this.quantity,
    this.carts,
    this.totalPrice,
    this.taxes,
    this.shippingFee,
    this.loyaltyPoint
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? '',
      productId: json['product_id'] ?? '',
      color: json['color'] ?? '',
      quantity: json['quantity'] ?? 0,
      carts: json['productInfo'] != null ? ProductCart.fromJson(json['productInfo']) : null,
      totalPrice: json['totalPrice'] ?? 0,
      taxes: json['taxes'] ?? 0,
      shippingFee: json['shippingFee'] ?? 0,
      loyaltyPoint: (json['loyaltyPoint'] as num?)?.toDouble() ?? 0.0,
    );
  }

}