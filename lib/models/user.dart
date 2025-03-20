import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserModel {
  
  @JsonKey(name: '_id')
  final String? id;
  final String? email;
  final String? fullName;
  final String? password;
  final ShippingAddress? shippingAddress;
  @JsonKey(includeIfNull: false)
  final String? imageUrl;

  UserModel({
    this.id,
    required this.email,
    required this.fullName,
    this.password,
    required this.shippingAddress,
    this.imageUrl
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id, 
      "email": email,
      "fullName": fullName,
      "password": password,
      "imageUrl": imageUrl,
      "shippingAddress": shippingAddress?.toJson(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      imageUrl: json['imageUrl'], 
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(json['shippingAddress'])
          : null,
    );
  }

}