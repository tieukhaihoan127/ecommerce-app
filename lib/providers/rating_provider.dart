import 'package:ecommerce_app/models/add_rating.dart';
import 'package:ecommerce_app/models/add_review.dart';
import 'package:ecommerce_app/models/coupon.dart';
import 'package:ecommerce_app/models/rating.dart';
import 'package:ecommerce_app/models/review.dart';
import 'package:ecommerce_app/repositories/coupon_repository.dart';
import 'package:ecommerce_app/repositories/rating_repository.dart';
import 'package:ecommerce_app/repositories/review_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingProvider with ChangeNotifier{

  final RatingRepository _ratingRepository = RatingRepository();

  List<RatingModel>? _rating;

  List<RatingModel>? get rating => _rating;

  bool _isLoading = false;

  bool get isLoading => _isLoading;    

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<void> loadRatings(String productId) async {
    _isLoading = true;
    _rating = [];
    notifyListeners();

    try { 
      final ratings = await _ratingRepository.getAllRating(productId);
      if(ratings.isNotEmpty) {
        _rating = (ratings as List).map<RatingModel>((item) => RatingModel.fromJson(item)).toList();
      }

      print("Data response: $_rating");

      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> addRating(String productId, String message, double star) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? tokenId = prefs.getString('token');

      var rating = AddRatingModel(
        productId: productId,
        tokenId: tokenId,
        message: message,
        rating: star
      );

      final ratingResponse = await _ratingRepository.addRating(rating);

      _rating?.insert(0,RatingModel.fromJson(ratingResponse));

      _errorMessage = "";
      notifyListeners();

      return "Đã thêm rating thành công!";
    
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

    return "";
  }

}