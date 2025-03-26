import 'package:ecommerce_app/widgets/home_drawer_item.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
            ),
            child: Text(
              "🚀 ido",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                HomeDrawerItem(icon: Icons.home, title: "Home", subItems: ["Home Variant 1", "Home Variant 2"]),
                HomeDrawerItem(icon: Icons.category, title: "Category", subItems: ["Category Variant 1", "Category Variant 2"]),
                HomeDrawerItem(icon: Icons.shopping_bag, title: "My Bag", subItems: ["My Bag Variant 1", "My Bag Variant 2"]),
                HomeDrawerItem(icon: Icons.shopping_cart, title: "Product", subItems: ["My Product Variant 1", "My Product Variant 2", "My Product Variant 3"]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}