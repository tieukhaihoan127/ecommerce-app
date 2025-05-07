import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../controllers/menu_app_controller.dart';
import '../../../responsive.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/GearHouse.png"),
          ),
          DrawerListTile(
            title: "Quản lý chung",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              context.read<MenuAppController>().changePage(AppPage.dashboard);
            },
          ),
          DrawerListTile(
            title: "Doanh thu",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              context.read<MenuAppController>().changePage(AppPage.revenue);
              if (Responsive.isMobile(context))
                Navigator.pop(context); // Đóng drawer
            },
          ),
          DrawerListTile(
            title: "Hóa đơn",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              context.read<MenuAppController>().changePage(AppPage.invoice);
              if (Responsive.isMobile(context))
                Navigator.pop(context); // Đóng drawer
            },
          ),
          DrawerListTile(
            title: "Quản lý sản phẩm",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              context.read<MenuAppController>().changePage(AppPage.product);
              if (Responsive.isMobile(context))
                Navigator.pop(context); // Đóng drawer
            },
          ),
          DrawerListTile(
            title: "Quản lý tài khoản người dùng",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              context.read<MenuAppController>().changePage(AppPage.user);
              if (Responsive.isMobile(context))
                Navigator.pop(context); // Đóng drawer
            },
          ),
          DrawerListTile(
            title: "Quản lý Coupon",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              context.read<MenuAppController>().changePage(AppPage.coupon);
              if (Responsive.isMobile(context))
                Navigator.pop(context); // Đóng drawer
            },
          ),
        ],
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
        colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
        height: 20,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
