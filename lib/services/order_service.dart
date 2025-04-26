import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/add_to_cart.dart';
import 'package:ecommerce_app/models/checkout_order.dart';

class OrderService {

  final Dio _dio = Dio();

  Future<String> addOrders(CheckoutOrderModel order) async {
    try {

      Response response = await _dio.post(
        ApiConfig.checkoutUrl,
        data: order.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 200 && response.data["message"] != null){
        return response.data["message"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không thêm được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Thêm đơn hàng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

  Future<List<Map<String, dynamic>>> getHistoryOrders(String tokenId) async {
    try {

      Response response = await _dio.post(
        ApiConfig.getOrderHistoryUrl,
        data: ({"tokenId": tokenId}),
        options: Options(headers: {'Content-Type': 'application/json'}) 
      );
      if(response.statusCode == 200 && response.data["order"] != null){
        List orders = response.data["order"];
        return orders.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
      }
      else {
        return await Future.error("Lỗi hệ thống, không thêm được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Thêm đơn hàng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

}