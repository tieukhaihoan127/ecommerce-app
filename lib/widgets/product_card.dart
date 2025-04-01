import 'package:ecommerce_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {

  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: product.thumbnail != "" ? NetworkImage(product.thumbnail!) : NetworkImage('https://res.cloudinary.com/dwdhkwu0r/image/upload/v1742743354/public/lafrmfp3o9jdgbl4csnb.jpg'),
                    fit: BoxFit.cover, 
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       product.title != "" ? product.title! : "Unknown",
            //       style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            //     ),
            //     Row(
            //       children: [
            //         Icon(Icons.star, color: Colors.orange, size: 16),
            //         SizedBox(width: 1),
            //         Text('5.0', style: TextStyle(fontSize: 14)),
            //       ],
            //     )
            //   ],
            // ),
            Text(
              product.title != "" ? product.title! : "Unknown",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.price! > 0.0 ? product.price!.toString() : "Unknown Price",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 16,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}