class CategoryPageModel {
  
  final String id;
  final String name;
  final String imageUrl;
  final int productCount;

  CategoryPageModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.productCount
  });

  @override
  String toString() {
    return 'Category(id: $id,name: $name,imageUrl: $imageUrl)';
  }

  factory CategoryPageModel.fromJson(Map<String, dynamic> json) {
    return CategoryPageModel(
      id:  json['_id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      productCount: json['productCount'] ?? 0
    );
  }

}