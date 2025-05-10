import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserModel {
  
  @JsonKey(name: '_id')
  String? id;
  String? email;
  String? fullName;
  ShippingAddress? shippingAddress;
  @JsonKey(includeIfNull: false)
  String? imageUrl;
  bool? isAdmin;

  UserModel({
    this.id,
    required this.email,
    required this.fullName,
    this.shippingAddress,
    this.imageUrl,
    this.isAdmin
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id, 
      "email": email,
      "fullName": fullName,
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
      isAdmin: json['isAdmin']
    );
  }

}