import 'package:ecommerce_app/models/product_variant.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProductModel {
  String? id;
  String? title;
  String? description;
  String? color;
  String? sku;
  String? brand;
  double? price;
  double? discountPercentage;
  int? stock;
  String? thumbnail;
  List<String>? images;
  List<ProductVariant>? variant;
  double? averageRating;



  ProductModel({
    this.id,
    this.title,
    this.description,
    this.color,
    this.sku,
    this.brand,
    this.price,
    this.discountPercentage,
    this.stock,
    this.thumbnail,
    this.images,
    this.variant,
    this.averageRating
  });

  @override
  String toString() {
    return 'ProductModel(title: $title, description: $description, thumbnail: $thumbnail, price: $price, discountPercentage: $discountPercentage, images: $images, variant: $variant))';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      color: json['color'] ?? '',
      sku: json['sku'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images']) ?? [],
      variant: (json['variant'] as List?)?.map((item) => ProductVariant.fromJson(item)).toList() ?? [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

}