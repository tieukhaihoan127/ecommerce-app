import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserOrderDetail {
  
  String? email;
  String? fullName;
  String? phone;
  String? city;
  String? district;
  String? ward;
  String? address;

  UserOrderDetail({
    this.email,
    this.fullName,
    this.phone,
    this.city,
    this.district,
    this.ward,
    this.address
  });

  factory UserOrderDetail.fromJson(Map<String, dynamic> json) {
    return UserOrderDetail(
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      address: json['address'] ?? '',
    );
  }

}