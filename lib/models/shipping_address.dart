class ShippingAddress {
  
  final String city;
  final String district;
  final String ward;
  final String address;

  ShippingAddress({
    required this.city,
    required this.district,
    required this.ward,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "district": district,
      "ward": ward,
      "address": address,
    };
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      address: json['address'] ?? '',
    );
  }

}