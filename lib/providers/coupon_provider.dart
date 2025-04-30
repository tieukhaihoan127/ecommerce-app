import 'package:ecommerce_app/models/coupon.dart';
import 'package:ecommerce_app/repositories/coupon_repository.dart';
import 'package:flutter/material.dart';

class CouponProvider with ChangeNotifier{

  final CouponRepository _couponRepositoroy = CouponRepository();

  List<CouponModel>? _coupon;

  List<CouponModel>? get coupon => _coupon;

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
      final coupons = await _couponRepositoroy.getAllCoupons();
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