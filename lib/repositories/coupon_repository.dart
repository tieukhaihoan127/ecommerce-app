import 'package:ecommerce_app/models/add_coupon.dart';
import 'package:ecommerce_app/services/coupon_service.dart';

class CouponRepository {

  final CouponService _couponService = CouponService();

  Future<List<Map<String,dynamic>>> getAllCoupons() => _couponService.getCoupons();

  Future<List<Map<String,dynamic>>> getAllCouponsAdmin() => _couponService.getCouponsAdmin();

  Future<String> addCoupon(AddCouponModel coupon) => _couponService.addCoupon(coupon);

}