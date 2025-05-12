import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserAdminModel {
  
  @JsonKey(name: '_id')
  String? id;
  String? email;
  String? fullName;
  ShippingAddress? shippingAddress;
  String? imageUrl;
  String? status;

  UserAdminModel({
    this.id,
    required this.email,
    required this.fullName,
    this.shippingAddress,
    this.imageUrl,
    this.status
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "fullName": fullName,
      "shippingAddress": shippingAddress?.toJson(),
      "status": status
    };
  }

  factory UserAdminModel.fromJson(Map<String, dynamic> json) {
    return UserAdminModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      imageUrl: json['imageUrl'], 
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(json['shippingAddress'])
          : null,
      status: json['status'] ?? ''
    );
  }

}