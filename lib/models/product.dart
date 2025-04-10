import 'package:cloudinary_url_gen/config/url_config.dart';
import 'package:ecommerce_app/models/product_variant.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProductModel {
  String? id;
  String? title;
  String? description;
  double? price;
  double? discountPercentage;
  String? thumbnail;
  List<String>? images;
  List<ProductVariant>? variant;



  ProductModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.thumbnail,
    this.images,
    this.variant
  });


  // Map<String, dynamic> toJson() {
  //   return {
  //     if (id != null) "_id": id, 
  //     "email": email,
  //     "fullName": fullName,
  //     "password": password,
  //     "imageUrl": imageUrl,
  //     "shippingAddress": shippingAddress?.toJson(),
  //   };
  // }

  @override
  String toString() {
    return 'ProductModel(title: $title, description: $description, thumbnail: $thumbnail, price: $price, discountPercentage: $discountPercentage, images: $images, variant: $variant))';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images']) ?? [],
      variant: (json['variant'] as List?)?.map((item) => ProductVariant.fromJson(item)).toList() ?? [],
    );
  }

}