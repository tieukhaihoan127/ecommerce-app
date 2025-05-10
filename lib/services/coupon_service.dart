import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/add_coupon.dart';


class CouponService {

  final Dio _dio = Dio();

  Future<List<Map<String,dynamic>>> getCoupons() async{
    try {
      Response response = await _dio.get(ApiConfig.getCouponCodeUrl);
      if (response.statusCode == 200 && response.data["coupons"].length > 0) {
        return List<Map<String, dynamic>>.from(response.data["coupons"]);
      }
      throw Exception('Failed to load coupon');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<List<Map<String,dynamic>>> getCouponsAdmin() async{
    try {
      Response response = await _dio.get(ApiConfig.getCouponCodeAdminUrl);
      if (response.statusCode == 200 && response.data["coupons"].length > 0) {
        return List<Map<String, dynamic>>.from(response.data["coupons"]);
      }
      throw Exception('Failed to load coupon');

    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}"); 
      rethrow;
    } 
  }

  Future<String> addCoupon(AddCouponModel coupon) async{
    try {

      Response response = await _dio.post(
        ApiConfig.addCouponUrl,
        data: coupon.toJson(),
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
      rethrow;
    } 
  }

}