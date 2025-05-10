import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/screens/admin/coupon_screen.dart';
import 'package:ecommerce_app/screens/admin/create_coupon.dart';
import 'package:ecommerce_app/screens/admin/dashboard_screen.dart';
import 'package:ecommerce_app/screens/admin/invoice_screen.dart';
import 'package:ecommerce_app/screens/admin/order_coupon_screen.dart';
import 'package:ecommerce_app/screens/admin/product_screen.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/screens/admin/revenue_screen.dart';
import 'package:ecommerce_app/screens/admin/side_menu.dart';
import 'package:ecommerce_app/screens/admin/user_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedPage = context.watch<AdminProvider>().selectedPage;
    final selectedCouponId = context.watch<AdminProvider>().selectedCouponId;

    Widget bodyContent;
    switch (selectedPage) {
      case AppPage.revenue:
        bodyContent = RevenueScreen();
        break;
      case AppPage.invoice:
        bodyContent = InvoiceScreen();
        break;
      case AppPage.coupon:
        bodyContent = CouponScreen();
        break;
      case AppPage.user:
        bodyContent = UserManagementScreen();
        break;
      case AppPage.product:
        bodyContent = ProductScreen();
        break;
      case AppPage.couponOrder:
        bodyContent = OrderCouponScreen(couponId: selectedCouponId ?? '',);
        break;
      case AppPage.createCoupon:
        bodyContent = CreateCouponScreen();
        break;
      case AppPage.dashboard:
      default:
        bodyContent = DashboardScreen();
    }

    return Theme(
      data: ThemeData.dark().copyWith(
        canvasColor: secondaryColor,
        scaffoldBackgroundColor: bgColor,
        textTheme: ThemeData.dark().textTheme.copyWith(
          bodyLarge: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white70),
        ),
        iconTheme: const IconThemeData(color: Colors.white54),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white70,
          iconColor: Colors.white54,
        ),
      ),
      child: Scaffold(
        key: context.read<AdminProvider>().scaffoldKey,
        drawer: SideMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // We want this side menu only for large screen
              if (Responsive.isDesktop(context))
                Expanded(
                  child: SideMenu(),
                ),
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: bodyContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}