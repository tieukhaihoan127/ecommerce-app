import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int productCount;

  CategoryCard({required this.name, required this.imageUrl, required this.productCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Total $productCount items available'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
