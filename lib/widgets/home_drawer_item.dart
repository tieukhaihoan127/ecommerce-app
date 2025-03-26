import 'package:flutter/material.dart';

class HomeDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> subItems;

  HomeDrawerItem({required this.icon, required this.title, required this.subItems});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: subItems
          .map((subItem) => Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5),
                child: ListTile(
                  title: Text("- $subItem", style: TextStyle(color: Colors.grey[700])),
                  onTap: () {},
                ),
              ))
          .toList(),
    );
  }
}