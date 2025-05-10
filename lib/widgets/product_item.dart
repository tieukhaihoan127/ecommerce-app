import 'package:ecommerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget{

  final ProductModel product;

  const ProductItem({super.key, required this.product});

  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: constraints.maxWidth * 0.6,
                        width: double.infinity,
                        child: Image.network(
                          product.thumbnail!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.title ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    product.discountPercentage! > 0.0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_formatCurrency(product.price! * (1 - product.discountPercentage! / 100))} đ",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "${_formatCurrency(product.price!)} đ",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "${_formatCurrency(product.price!)} đ",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                    if (product.averageRating! > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            product.averageRating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _formatCurrency(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}