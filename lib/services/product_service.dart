import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/product.dart';


class ProductService {

  final Dio _dio = Dio();

  Future<List<Map<String,dynamic>>> getProducts(String status) async{
    try {

      if(status == "") {
        status = "All";
      }

      Response response = await _dio.get("${ApiConfig.getProductsUrl}$status");
      if (response.statusCode == 200 && response.data["products"].length > 0) {
        return List<Map<String, dynamic>>.from(response.data["products"]);
      }
      throw Exception('Failed to load products');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }
}