import 'package:ecommerce_app/models/product_order_history.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderStatusModel {
  String? status;
  DateTime? updatedAt;

  OrderStatusModel({
    this.status,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'OrderStatusModel(status: $status, updatedAt: $updatedAt)';
  }

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      status: json['status'] ?? '',
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

}