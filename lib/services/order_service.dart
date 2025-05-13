import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
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
        return await Future.error("Lỗi hệ thống, không lấy được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Lấy thông tin tất cả đơn hàng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

  Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
    try {

      var url = "${ApiConfig.getOrderHistoryUrl}/$orderId";

      Response response = await _dio.get(url);
      if(response.statusCode == 200 && response.data["order"] != null){
        return response.data["order"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không lấy được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Lấy thông tin đơn hàng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

  Future<List<Map<String,dynamic>>> getOrderStatusDetail(String orderId) async {
    try {

      var url = "${ApiConfig.getOrderStatusUrl}/$orderId";

      Response response = await _dio.get(url);
      if(response.statusCode == 200 && response.data["status"] != null){
        List status = response.data["status"];
        return status.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
      }
      else {
        return await Future.error("Lỗi hệ thống, không lấy được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Lấy thông tin trạng thái đơn hàng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

  Future<List<Map<String,dynamic>>> getOrderUsingCoupon(String couponId) async{
    try {
      Response response = await _dio.get("${ApiConfig.getCouponCodeAdminUrl}/$couponId");
      if(response.statusCode == 200 && response.data["order"] != null){
        List orders = response.data["order"];
        return orders.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
      }
      else {
        return await Future.error("Lỗi hệ thống, không lấy được data!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<dynamic> getAdminOrder(String status, DateTime startDate, DateTime endDate, int page) async{
    try {

      var url = "${ApiConfig.getOrderAdminUrl}/$status?page=$page&limit=20";

      if(status == "Custom") {
        url = "${ApiConfig.getOrderAdminUrl}/$status?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}&page=$page&limit=20";
      }
      
      Response response = await _dio.get(url);
      if(response.statusCode == 200){
        return response.data;
      }
      else {
        return await Future.error("Lỗi hệ thống, không lấy được data!");
      }

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<Map<String, dynamic>> getAdminOrderDetail(String orderId) async {
    try {

      var url = "${ApiConfig.getOrderAdminDetailUrl}$orderId";

      Response response = await _dio.get(url);
      if(response.statusCode == 200 && response.data["order"] != null){
        return response.data["order"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không lấy được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Lấy thông tin đơn hàng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

  Future<String> updateOrderStatus(String orderId, String status) async {
    try {

      var url = "${ApiConfig.updateOrderStatusUrl}$orderId/$status";

      Response response = await _dio.patch(url);
      if(response.statusCode == 200 && response.data["message"] != null){
        return response.data["message"];
      }
      else {
        return await Future.error("Lỗi hệ thống, không thêm được data!");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Cập nhật đơn hàng thất bại!';
        return Future.error(errorMessage);
      }

      return Future.error("Lỗi kết nối! Vui lòng thử lại.");
    } 
  }

}