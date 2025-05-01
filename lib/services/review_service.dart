import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/add_review.dart';


class ReviewService {

  final Dio _dio = Dio();

  Future<List<Map<String,dynamic>>> getReviews(String productId) async{
    try {

      var url = "${ApiConfig.getReviewUrl}$productId";

      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data["reviews"]);
      }
      throw Exception('Failed to load review');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<Map<String,dynamic>> addReview(AddReviewModel review) async{
    try {

      Response response = await _dio.post(
        ApiConfig.addReviewUrl,
        data: review.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 201 && response.data["message"] != null){
        return response.data["review"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không thêm được data!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }
}