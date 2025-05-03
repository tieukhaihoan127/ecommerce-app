import 'package:flutter/material.dart';

/// Các trang trong ứng dụng
enum AppPage {
  dashboard,
  revenue,
  invoice,
  product,
  user,
  coupon,
}

class MenuAppController with ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AppPage _selectedPage = AppPage.dashboard;

  AppPage get selectedPage => _selectedPage;

  /// Hàm thay đổi trang và thông báo lại UI
  void changePage(AppPage page) {
    _selectedPage = page;
    notifyListeners();
  }

  /// Mở drawer nếu đang đóng
  void controlMenu() {
    if (!scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
    }
  }
}
