class ReviewModel {
  
  final String? message;
  final DateTime? createdDate;

  ReviewModel({
    this.message,
    this.createdDate
  });

  @override
  String toString() {
    return 'Review(message: $message,createdDate: $createdDate)';
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      message:  json['message'] ?? 0,
      createdDate: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }


}