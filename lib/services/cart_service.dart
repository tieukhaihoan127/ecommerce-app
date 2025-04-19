import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/add_to_cart.dart';
import 'package:ecommerce_app/models/delete_cart.dart';
import 'package:ecommerce_app/models/user_cart.dart';

class CartService {

  final Dio _dio = Dio();

  Future<Map<String,dynamic>> getCarts(UserCartModel user) async {
    try {
      Response response = await _dio.post(
        ApiConfig.getCartUrl,
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 200){
        return Map<String,dynamic>.from(response.data["cart"]);
      }
      throw Exception('Failed to load carts');
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<String> addCarts(AddToCartModel product, String productId) async {
    try {

      var url = "${ApiConfig.addCartUrl}$productId/";

      Response response = await _dio.post(
        url,
        data: product.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 201 && response.data["message"] != null){
        return response.data["message"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không thêm được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Thêm sản phẩm thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

  Future<String> deleteCarts(DeleteCartModel product, String productId) async {
    try {

      var url = "${ApiConfig.deleteCartUrl}$productId/";

      Response response = await _dio.post(
        url,
        data: product.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 200 && response.data["message"] != null){
        return response.data["message"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không xóa được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Xóa sản phẩm thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

  Future<String> updateCarts(AddToCartModel product, String productId) async {
    try {

      final encodedColor = Uri.encodeComponent(product.color ?? '');
      var url = "${ApiConfig.updateCartUrl}$productId/${product.quantity}?color=$encodedColor";
      print("URL: $url");

      Response response = await _dio.patch(
        url,
        data: product.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 200 && response.data["message"] != null){
        return response.data["message"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không cập nhật được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Cập nhật sản phẩm thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }
}