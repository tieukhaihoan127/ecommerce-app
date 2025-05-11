import 'package:ecommerce_app/models/product_order_history.dart';
import 'package:ecommerce_app/models/product_order_history_detail.dart';
import 'package:ecommerce_app/models/user_order_detail.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderDetailAdminModel {
  String? orderId;
  double? totalPrice;
  List<ProductOrderHistoryDetail>? products;
  UserOrderDetail? userInfo;
  int? taxes;
  int? shippingFee;
  int? loyaltyPoint;
  int? coupon;
  DateTime? createdDate;
  String? status;

  OrderDetailAdminModel({
    this.orderId,
    this.totalPrice,
    this.products,
    this.userInfo,
    this.taxes,
    this.shippingFee,
    this.loyaltyPoint,
    this.coupon,
    this.createdDate,
    this.status
  });

  @override
  String toString() {
    return 'OrderHistoryModel(orderId: $orderId, totalPrice: $totalPrice, products: $products, userInfo: $userInfo, taxes: $taxes, shippingFee: $shippingFee)';
  }

  factory OrderDetailAdminModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailAdminModel(
      orderId: json['orderId'] ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      products: (json['products'] as List?)?.map((item) => ProductOrderHistoryDetail.fromJson(item)).toList(),
      userInfo: json['userInfo'] != null ? UserOrderDetail.fromJson(json['userInfo']) : null,
      taxes: json['taxes'] ?? 0,
      shippingFee: json['shippingFee'] ?? 0,
      loyaltyPoint: json['loyaltyPoint'] ?? 0,
      coupon: json['couponPoint'] ?? 0,
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
      status: json['status'] ?? '',
    );
  }

}