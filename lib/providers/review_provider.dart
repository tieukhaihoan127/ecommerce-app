import 'package:ecommerce_app/models/add_review.dart';
import 'package:ecommerce_app/models/review.dart';
import 'package:ecommerce_app/repositories/review_repository.dart';
import 'package:flutter/material.dart';

class ReviewProvider with ChangeNotifier{

  final ReviewRepository _reviewRepository = ReviewRepository();

  List<ReviewModel>? _review;

  List<ReviewModel>? get review => _review;

  bool _isLoading = false;

  bool get isLoading => _isLoading;    

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<void> loadReviews(String productId) async {
    _isLoading = true;
    _review = [];
    notifyListeners();

    try { 
      final reviews = await _reviewRepository.getAllReview(productId);
      if(reviews.isNotEmpty) {
        _review = (reviews as List).map<ReviewModel>((item) => ReviewModel.fromJson(item)).toList();
      }

      print("Data response: $_review");

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

  Future<String> addReview(String productId, String message) async {
    try {
      var review = AddReviewModel(
        productId: productId,
        message: message
      );

      final reviewResponse = await _reviewRepository.addReview(review);

      _review?.insert(0,ReviewModel.fromJson(reviewResponse));

      _errorMessage = "";
      notifyListeners();

      return "Đã thêm comment thành công!";
    
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

    return "";
  }
}