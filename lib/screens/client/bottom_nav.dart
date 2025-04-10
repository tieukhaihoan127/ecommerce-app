import 'package:ecommerce_app/screens/client/cart.dart';
import 'package:ecommerce_app/screens/client/category.dart';
import 'package:ecommerce_app/screens/client/home.dart';
import 'package:ecommerce_app/screens/client/order.dart';
import 'package:ecommerce_app/screens/client/profile.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();

}

class _BottomNavBarState extends State<BottomNavBar> {

  int _selectedScreenIndex = 0;

  final List<Widget>  _screens = [
    HomeScreen(),
    CategoryScreen(),
    Cart(),
    Order(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreenIndex = index;
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
        items: [
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