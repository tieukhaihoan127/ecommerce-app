import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';


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

  Future<List<Map<String,dynamic>>> getProductPages(String status, String? sortById, List<String>? selectedBrands, double? priceRangeStart, double? priceRangeEnd, double? ratingRangeStart, double? ratingRangeEnd, String? search) async{
    try {

      if(status == "") {
        status = "All";
      }

    String url = "${ApiConfig.getProductPagesUrl}$status";

    List<String> queryParams = [];

    if (sortById != null) {
      queryParams.add("sortById=${Uri.encodeComponent(sortById)}");
    }

    if (selectedBrands != null && selectedBrands.isNotEmpty) {
      queryParams.addAll(
        selectedBrands.map((brand) => "brand=${Uri.encodeComponent(brand)}"),
      );
    }

    if (priceRangeStart != null && priceRangeEnd != null) {
      queryParams.add("priceStart=$priceRangeStart");
      queryParams.add("priceEnd=$priceRangeEnd");
    }

    if (ratingRangeStart != null && ratingRangeEnd != null) {
      queryParams.add("ratingStart=$ratingRangeStart");
      queryParams.add("ratingEnd=$ratingRangeEnd");
    }

    if(search != null) {
      queryParams.add("search=$search");
    }

    if (queryParams.isNotEmpty) {
      url += "?" + queryParams.join("&");
    }

      Response response = await _dio.get(url);
      if (response.statusCode == 200 && response.data["products"].length > 0) {
        print('Product Response:  ${List<Map<String, dynamic>>.from(response.data["products"])}');
        return List<Map<String, dynamic>>.from(response.data["products"]);
      }
      throw Exception('Failed to load products');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }
}