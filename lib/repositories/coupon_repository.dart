import 'package:ecommerce_app/services/category_service.dart';
import 'package:ecommerce_app/services/coupon_service.dart';

class CouponRepository {

  final CouponService _couponService = CouponService();

  Future<List<Map<String,dynamic>>> getAllCoupons() => _couponService.getCoupons();

}