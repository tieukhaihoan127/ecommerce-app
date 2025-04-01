class CategoryModel {
  
  final String id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Category(id: $id,name: $name)';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id:  json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name
    };
  }

}