import 'package:ecommerce_app/models/add_review.dart';
import 'package:ecommerce_app/services/review_service.dart';

class ReviewRepository {

  final ReviewService _reviewService = ReviewService();

  Future<List<Map<String,dynamic>>> getAllReview(String productId) => _reviewService.getReviews(productId);

  Future<Map<String,dynamic>> addReview(AddReviewModel review) => _reviewService.addReview(review);

}