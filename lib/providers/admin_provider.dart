import 'package:flutter/material.dart';

/// Các trang trong ứng dụng
enum AppPage {
  dashboard,
  revenue,
  invoice,
  product,
  user,
  coupon,
  couponOrder,
  createCoupon
}

class AdminProvider with ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AppPage _selectedPage = AppPage.dashboard;

  AppPage get selectedPage => _selectedPage;

  String? _selectedCouponId;

  String? get selectedCouponId => _selectedCouponId;

  /// Hàm thay đổi trang và thông báo lại UI
  void changePage(AppPage page, {String? couponId}) {
    _selectedPage = page;
    _selectedCouponId = couponId;
    notifyListeners();
  }

  /// Mở drawer nếu đang đóng
  void controlMenu() {
    if (!scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
    }
  }
}