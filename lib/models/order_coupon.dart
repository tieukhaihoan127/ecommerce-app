import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderCouponModel {
  String? orderId;
  double? totalAmount;
  String? latestStatus;
  DateTime? latestUpdatedAt;

  OrderCouponModel({
    this.orderId,
    this.totalAmount,
    this.latestStatus,
    this.latestUpdatedAt
  });

  @override
  String toString() {
    return 'OrderHistoryModel(orderId: $orderId, totalAmount: $totalAmount, latestStatus: $latestStatus, latestUpdatedAt: $latestUpdatedAt)';
  }

  factory OrderCouponModel.fromJson(Map<String, dynamic> json) {
    return OrderCouponModel(
      orderId: json['orderId'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      latestStatus: json['latestStatus'] ?? '',
      latestUpdatedAt: json['latestUpdatedAt'] != null ? DateTime.parse(json['latestUpdatedAt']) : null,
    );
  }

}