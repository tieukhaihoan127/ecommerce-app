class ProductCart {

  final String? title;
  final int? price;
  final double? discountPercentage;
  final String? thumbnail;
  final int? priceNew;

  ProductCart({
    this.title,
    this.price,
    this.discountPercentage,
    this.thumbnail,
    this.priceNew
  });

  factory ProductCart.fromJson(Map<String, dynamic> json) {
    return ProductCart(
      title: json['title'] ?? '',
      price: json['price'] ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] ?? '',
      priceNew: json['priceNew'] ?? 0
    );
  }

}