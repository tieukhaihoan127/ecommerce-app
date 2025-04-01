class ProductVariant {
  
  final String? color;
  final String? thumbnail;
  final List<String>? carousel;
  final double? price;
  final double? discountPercentage;
  final String? sku;
  final int? stock;

  ProductVariant({
    this.color,
    this.thumbnail,
    this.carousel,
    this.price,
    this.discountPercentage,
    this.sku,
    this.stock
  });

  @override
  String toString() {
    return 'ProductVariant(color: $color, thumbnail: $thumbnail, carousel: $carousel, price: $price, discountPercentage: $discountPercentage, sku: $sku, stock: $stock))';
  }


  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      color: json['color'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      carousel: List<String>.from(json['carousel']) ?? [],
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      sku: json['sku'] ?? '',
      stock: json['stock'] ?? '',
    );
  }

}