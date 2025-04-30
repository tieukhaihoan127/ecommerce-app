import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';


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
}