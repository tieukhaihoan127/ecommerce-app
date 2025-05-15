import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CheckoutOrderModel {
  String? cartId;
  String? email;
  String? phone;
  String? fullName;
  String? city; 
  String? ward; 
  String? district;
  String? address;
  bool? loyaltyPointUsed;
  int? couponPoint;
  String? couponCode;

  CheckoutOrderModel({
    this.cartId,
    this.email,
    this.phone,
    this.fullName,
    this.city,
    this.ward,
    this.district,
    this.address,
    this.loyaltyPointUsed,
    this.couponPoint,
    this.couponCode
  });

  Map<String, dynamic> toJson() {
    return {
      "cartId": cartId,
      "email": email,
      "phone": phone,
      "fullName": fullName,
      "city": city,
      "ward": ward,
      "district": district,
      "address": address,
      "loyaltyPointUsed": loyaltyPointUsed,
      "couponValue": couponPoint,
      "couponId": couponCode
    };
  }

}