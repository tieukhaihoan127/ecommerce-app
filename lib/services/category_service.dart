import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';


class CategoryService {

  final Dio _dio = Dio();

  Future<List<Map<String,dynamic>>> getCategories() async{
    try {
      Response response = await _dio.get(ApiConfig.getCategoriesUrl);
      if (response.statusCode == 200 && response.data["categories"].length > 0) {
        return List<Map<String, dynamic>>.from(response.data["categories"]);
      }
      throw Exception('Failed to load products');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }
}