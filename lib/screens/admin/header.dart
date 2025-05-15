import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/screens/admin/admin_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    final selectedPage = context.watch<AdminProvider>().selectedPage;
    var title = "Quản lý";
    if (selectedPage == AppPage.revenue) {
      title += " doanh thu";
    } else if (selectedPage == AppPage.invoice) {
      title += " hóa đơn";
    } else if (selectedPage == AppPage.product) {
      title += " sản phẩm";
    } else if (selectedPage == AppPage.user) {
      title += " tài khoản người dùng";
    } else if (selectedPage == AppPage.coupon) {
      title += " Coupon";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: context.read<AdminProvider>().controlMenu,
              ),
            if (!Responsive.isMobile(context))
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminChatPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, 
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Chat',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
