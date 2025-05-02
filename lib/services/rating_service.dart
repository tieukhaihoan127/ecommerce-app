import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/add_rating.dart';


class RatingService {

  final Dio _dio = Dio();

  Future<List<Map<String,dynamic>>> getRatings(String productId) async{
    try {

      var url = "${ApiConfig.getRatingUrl}$productId";

      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data["ratings"]);
      }
      throw Exception('Failed to load rating');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<Map<String,dynamic>> addRating(AddRatingModel rating) async{
    try {

      Response response = await _dio.post(
        ApiConfig.addRatingUrl,
        data: rating.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 201 && response.data["message"] != null){
        return response.data["rating"];
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