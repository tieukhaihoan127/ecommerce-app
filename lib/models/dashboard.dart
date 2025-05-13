import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashboardModel {
  
  int? totalUser;
  int? newUser;
  int? totalOrders;
  int? revenue;
  int? totalBestSellingSold;
  List<int>? orderCountList;
  List<int>? revenueList;

  DashboardModel({
    this.totalUser,
    this.newUser,
    this.totalOrders,
    this.revenue,
    this.totalBestSellingSold,
    this.orderCountList,
    this.revenueList
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalUser: json['totalUser'] ?? 0,
      newUser: json['newUser'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0, 
      revenue: json['revenue'] ?? 0, 
      totalBestSellingSold: json['totalBestSellingSold'] ?? 0, 
      orderCountList: (json['orderCountList'] as List?) ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0).toList() ?? [],
      revenueList: (json['revenueList'] as List?) ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0).toList() ?? [],
    );
  }

}