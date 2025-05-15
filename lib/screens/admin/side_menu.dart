import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo.png"),
            ),
            DrawerListTile(
              title: "Quản lý chung",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {
                context.read<AdminProvider>().changePage(AppPage.dashboard);
              },
            ),
            DrawerListTile(
              title: "Hóa đơn",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {
                context.read<AdminProvider>().changePage(AppPage.invoice);
                if (Responsive.isMobile(context))
                  Navigator.pop(context); // Đóng drawer
              },
            ),
            DrawerListTile(
              title: "Quản lý tài khoản người dùng",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {
                context.read<AdminProvider>().changePage(AppPage.user);
                if (Responsive.isMobile(context))
                  Navigator.pop(context); // Đóng drawer
              },
            ),
            DrawerListTile(
              title: "Quản lý Coupon",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                context.read<AdminProvider>().changePage(AppPage.coupon);
                if (Responsive.isMobile(context))
                  Navigator.pop(context); // Đóng drawer
              },
            ),
            DrawerListTile(
              title: "Thoát giao diện",
              svgSrc: "assets/icons/drop_box.svg",
              press: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}