import 'package:ecommerce_app/models/add_rating.dart';
import 'package:ecommerce_app/services/rating_service.dart';

class RatingRepository {

  final RatingService _ratingService = RatingService();

  Future<List<Map<String,dynamic>>> getAllRating(String productId) => _ratingService.getRatings(productId);

  Future<Map<String,dynamic>> addRating(AddRatingModel rating) => _ratingService.addRating(rating);

}