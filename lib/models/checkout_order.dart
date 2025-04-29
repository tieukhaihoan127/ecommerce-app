import 'package:ecommerce_app/models/product_cart.dart';
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

  CheckoutOrderModel({
    this.cartId,
    this.email,
    this.phone,
    this.fullName,
    this.city,
    this.ward,
    this.district,
    this.address,
    this.loyaltyPointUsed
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
      "loyaltyPointUsed": loyaltyPointUsed
    };
  }

}