import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/config/api_config.dart';
import 'package:ecommerce_app/models/district.dart';
import 'package:ecommerce_app/models/province.dart';
import 'package:ecommerce_app/models/ward.dart';
import 'package:flutter/material.dart';

class AddressService {

  final Dio _dio = Dio();

  Future<List<Province>> fetchProvince() async {
    try {
      final response = await _dio.get(ApiConfig.cityUrl);

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['data']['data'] is List) {
          return (response.data['data']['data'] as List)
              .map((json) => Province.fromJson(json))
              .toList();
        } else {
          throw Exception("API trả về không đúng định dạng!");
        }
      } else {
        throw Exception("Lỗi kết nối, mã lỗi: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Lỗi khi tải danh sách tỉnh thành: $e");
      throw Exception("Không thể tải danh sách tỉnh thành!");
    }
  }

  Future<List<District>> fetchDistrictByProvinceId(String id) async {
    try {
      final response = await _dio.get('${ApiConfig.districtUrl}${int.parse(id)}&limit=-1');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['data']['data'] is List) {
          return (response.data['data']['data'] as List)
              .map((json) => District.fromJson(json))
              .toList();
        } else {
          throw Exception("API trả về không đúng định dạng!");
        }
      } else {
        throw Exception("Lỗi kết nối, mã lỗi: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Lỗi khi tải danh sách: $e");
      throw Exception("Không thể tải danh sách!");
    }
  }

  Future<List<Ward>> fetchWardByDistrictId(String id) async {
    try {
      final response = await _dio.get('${ApiConfig.wardUrl}${int.parse(id)}&limit=-1');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['data']['data'] is List) {
          return (response.data['data']['data'] as List)
              .map((json) => Ward.fromJson(json))
              .toList();
        } else {
          throw Exception("API trả về không đúng định dạng!");
        }
      } else {
        throw Exception("Lỗi kết nối, mã lỗi: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Lỗi khi tải danh sách: $e");
      throw Exception("Không thể tải danh sách!");
    }
  }

}