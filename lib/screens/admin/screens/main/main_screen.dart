import 'package:ecommerce_app/screens/admin/screens/dashboard/coupon_screen.dart';
import 'package:ecommerce_app/screens/admin/screens/dashboard/invoice_screen.dart';
import 'package:ecommerce_app/screens/admin/screens/dashboard/product_screen.dart';
import 'package:ecommerce_app/screens/admin/screens/dashboard/user_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/menu_app_controller.dart';
import '../../responsive.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/revenue_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedPage = context.watch<MenuAppController>().selectedPage;

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
      case AppPage.dashboard:
      default:
        bodyContent = DashboardScreen();
    }

    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
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
    );
  }
}
