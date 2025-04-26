import 'package:ecommerce_app/models/product_order_history.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderHistoryModel {
  String? orderId;
  double? totalAmount;
  String? latestStatus;
  DateTime? latestUpdatedAt;
  List<ProductOrderHistory>? products;

  OrderHistoryModel({
    this.orderId,
    this.totalAmount,
    this.latestStatus,
    this.latestUpdatedAt,
    this.products,
  });

  @override
  String toString() {
    return 'OrderHistoryModel(orderId: $orderId, totalAmount: $totalAmount, latestStatus: $latestStatus, latestUpdatedAt: $latestUpdatedAt, products: $products)';
  }

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      orderId: json['orderId'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      latestStatus: json['latestStatus'] ?? '',
      latestUpdatedAt: json['latestUpdatedAt'] != null ? DateTime.parse(json['latestUpdatedAt']) : null,
      products: (json['product'] as List?)?.map((item) => ProductOrderHistory.fromJson(item)).toList()
    );
  }

}