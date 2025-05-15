import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/screens/client/cart.dart';
import 'package:ecommerce_app/screens/client/category.dart';
import 'package:ecommerce_app/screens/client/home.dart';
import 'package:ecommerce_app/screens/client/order_history.dart';
import 'package:ecommerce_app/screens/client/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedScreenIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    OrderHistoryPageScreen(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedScreenIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreenIndex = index;

      if (index == 2) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final couponProvider = Provider.of<CouponProvider>(context, listen: false);
        couponProvider.resetCode();
        couponProvider.resetValue();
        cartProvider.clearCart();
        cartProvider.getAllCarts();
      }

      if (index == 3) {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        orderProvider.clearOrder();
        orderProvider.getAllHistoryOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Order"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
