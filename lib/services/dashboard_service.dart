import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';

class DashboardService {

  final Dio _dio = Dio();

  Future<dynamic> getDashboard(String status, DateTime startDate, DateTime endDate) async {
    try {

      var url = "${ApiConfig.getDashboardUrl}$status";

      if(status == "Custom") {
        url = "${ApiConfig.getDashboardUrl}$status?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}";
      }

      Response response = await _dio.get(url);
      if(response.statusCode == 200 && response.data != null){
        return response.data;
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

}