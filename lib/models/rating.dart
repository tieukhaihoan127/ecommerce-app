class RatingModel {
  
  final String? imageUrl;
  final String? name;
  final String? message;
  final double? rating;
  final DateTime? createdDate;

  RatingModel({
    this.imageUrl,
    this.name,
    this.message,
    this.rating,
    this.createdDate
  });

  @override
  String toString() {
    return 'Rating(imageUrl: $imageUrl,name: $name,createdDate: $createdDate)';
  }

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      imageUrl:  json['imageUrl'] ?? "",
      name:  json['name'] ?? 0,
      message: json['comment'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
    );
  }


}