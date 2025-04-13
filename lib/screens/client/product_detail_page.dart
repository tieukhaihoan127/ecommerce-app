import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/product_variant.dart';
import 'package:ecommerce_app/widgets/app_bar_product.dart';
import 'package:ecommerce_app/widgets/carousel_product.dart';
import 'package:ecommerce_app/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {

  final ProductModel productModel;

  const ProductDetailPage({super.key, required this.productModel});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  ProductVariant? productVariant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProductHelper(categoryName: "Laptop",), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselProduct(imagePaths: productVariant?.carousel ??  widget.productModel.images!),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        widget.productModel.title!,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${productVariant?.discountPercentage ?? widget.productModel.discountPercentage}% OFF',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _colorDot(
                        widget.productModel.color!,
                        isSelected: productVariant == null,
                        onTap: () {
                          setState(() {
                            productVariant = null;
                          });
                        }
                      ),
                      ...widget.productModel.variant!.map((item) {
                        return _colorDot(
                          item.color!,
                          isSelected: productVariant?.color == item.color,
                          onTap: () {
                            setState(() {
                              productVariant = item;
                              quantity = 1;
                            });
                          }
                        );
                      })
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "${_formatCurrency(productVariant != null ? ((productVariant!.price! - (productVariant!.price!*productVariant!.discountPercentage!)/100)) : ((widget.productModel.price! - (widget.productModel.price!*widget.productModel.discountPercentage!)/100)))} đ",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${_formatCurrency(productVariant != null ? (productVariant!.price!) : (widget.productModel.price!))} đ",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            icon: Icon(Icons.remove_circle_outline),
                          ),
                          Text('$quantity'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                   ExpansionTileTheme(
                    data: ExpansionTileTheme.of(context).copyWith(
                      shape: Border(),
                      collapsedShape: Border()
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text("Product Information", style: TextStyle(fontWeight: FontWeight.bold)),
                      children: [
                        Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          children: [
                            TableRow(children: [
                              _tableCellLeft('Brand'),
                              _tableCellRight('${widget.productModel.brand}'),
                            ]),
                            TableRow(children: [
                              _tableCellLeft('SKU'),
                              _tableCellRight('${productVariant?.sku ?? widget.productModel.sku}'),
                            ]),
                            TableRow(children: [
                              _tableCellLeft('Stock'),
                              _tableCellRight('${productVariant?.stock ?? widget.productModel.stock}'),
                            ]),
                          ],
                        )
                      ],
                    ),
                  ),
                  ExpansionTileTheme(
                    data: ExpansionTileTheme.of(context).copyWith(
                      shape: Border(),
                      collapsedShape: Border()
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero, 
                      title: Text(
                        "Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text.rich(
                            TextSpan(
                              text:
                                  '${widget.productModel.description}',
                              children: [
                                TextSpan(
                                  text: "...Read More",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(color: Colors.black87, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionTileTheme(
                    data: ExpansionTileTheme.of(context).copyWith(
                      shape: Border(),
                      collapsedShape: Border()
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      initiallyExpanded: true,
                      title: Text("Reviews", style: TextStyle(fontWeight: FontWeight.w500)),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("156 Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text("View All", style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                            SizedBox(height: 12),
                            _reviewCard(
                              imageUrl: 'https://i.pravatar.cc/100?img=1',
                              name: 'Smith Williams',
                              time: 'Just Now',
                              rating: 4.5,
                              comment: 'I adore this item. Just fantastic!! they create the actual as seen in the picture !!',
                            ),
                            _reviewCard(
                              imageUrl: 'https://i.pravatar.cc/100?img=2',
                              name: 'Rina Jones',
                              time: '1 min ago',
                              rating: 4.2,
                              comment: 'The best product quality.! Its amazing, Love it...!!',
                            ),
                        
                            SizedBox(height: 8),
                        
                            Text(
                              "+ Write Your Review",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                        
                            SizedBox(height: 12),
                          ],
                        ),
                      ],
                    ),
                  )
              
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF0F1C2F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Add To Cart',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 1,
                    height: 32,
                    color: Colors.white24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "${_formatCurrency(productVariant != null ? ((productVariant!.price! - (productVariant!.price!*productVariant!.discountPercentage!)/100) * quantity) : ((widget.productModel.price! - (widget.productModel.price!*widget.productModel.discountPercentage!)/100) * quantity))} đ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorDot(String color, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: HexColor(color),
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: isSelected ? Colors.black : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _tableCellLeft(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text, style: TextStyle(fontWeight: FontWeight.bold),)),
    );
  }

  Widget _tableCellRight(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text)),
    );
  }
}

Widget _reviewCard({
  required String imageUrl,
  required String name,
  required String time,
  required double rating,
  required String comment,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 8),
        Text(comment, style: TextStyle(color: Colors.black)),
      ],
    ),
  );
}

String _formatCurrency(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}