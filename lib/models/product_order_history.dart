class ProductOrderHistory {
  
  final String? color;
  final String? title;
  final String? thumbnail;
  final double? price;
  final double? discountPercentage;
  final int? quantity;

  ProductOrderHistory({
    this.color,
    this.title,
    this.thumbnail,
    this.price,
    this.discountPercentage,
    this.quantity
  });

  @override
  String toString() {
    return 'ProductOrderHistory(color: $color, title: $title, thumbnail: $thumbnail, price: $price, discountPercentage: $discountPercentage, quantity: $quantity))';
  }


  factory ProductOrderHistory.fromJson(Map<String, dynamic> json) {
    return ProductOrderHistory(
      color: json['color'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
    );
  }

}