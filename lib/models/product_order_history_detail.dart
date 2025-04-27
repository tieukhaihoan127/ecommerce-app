class ProductOrderHistoryDetail {
  
  final String? color;
  final String? title;
  final String? thumbnail;
  final double? priceNew;
  final int? quantity;

  ProductOrderHistoryDetail({
    this.color,
    this.title,
    this.thumbnail,
    this.priceNew,
    this.quantity
  });

  @override
  String toString() {
    return 'ProductOrderHistoryDetail(color: $color, title: $title, thumbnail: $thumbnail, priceNew: $priceNew, quantity: $quantity))';
  }


  factory ProductOrderHistoryDetail.fromJson(Map<String, dynamic> json) {
    return ProductOrderHistoryDetail(
      color: json['color'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      priceNew: (json['priceNew'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
    );
  }

}