import 'package:ecommerce_app/models/add_coupon.dart';
import 'package:ecommerce_app/models/coupon.dart';
import 'package:ecommerce_app/models/coupon_admin.dart';
import 'package:ecommerce_app/repositories/coupon_repository.dart';
import 'package:flutter/material.dart';

class CouponProvider with ChangeNotifier{

  final CouponRepository _couponRepository = CouponRepository();

  List<CouponModel>? _coupon;

  List<CouponModel>? get coupon => _coupon;

  List<CouponAdminModel>? _couponAdmin;

  List<CouponAdminModel>? get couponAdmin => _couponAdmin;

  String? _code;

  String? get code => _code;

  int? _value = 0;

  int? get value => _value;

  bool _isLoading = false;

  bool get isLoading => _isLoading;    

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<void> loadCoupon() async {
    _isLoading = true;
    notifyListeners();

    try { 
      final coupons = await _couponRepository.getAllCoupons();
      if(coupons.isNotEmpty) {
        _coupon = (coupons as List).map<CouponModel>((item) => CouponModel.fromJson(item)).toList();
      }

      print("Data response: $_coupon");

      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCouponAdmin() async {
    _isLoading = true;
    notifyListeners();

    try { 
      final coupons = await _couponRepository.getAllCouponsAdmin();
      if(coupons.isNotEmpty) {
        _couponAdmin = (coupons as List).map<CouponAdminModel>((item) => CouponAdminModel.fromJson(item)).toList();
      }

      print("Data response: $_couponAdmin");

      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> addCoupon(String code, int discount, int stock) async {
    try {

      var coupon = AddCouponModel(
        code: code,
        discount: discount,
        stock: stock
      );

      final couponResponse = await _couponRepository.addCoupon(coupon);

      _errorMessage = "";
      notifyListeners();

      return couponResponse;
    
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

    return "";
  }

  void setCode(String code) {
    _code = code;
    notifyListeners();
  }

  void setValue(int value) {
    _value = value;
    notifyListeners();
  }

  void resetCode() {
    _code = "";
    notifyListeners();
  }

  void resetValue() {
    _value = 0;
    notifyListeners();
  }


}