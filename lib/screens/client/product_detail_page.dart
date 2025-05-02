import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/product_variant.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/rating_provider.dart';
import 'package:ecommerce_app/providers/review_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/widgets/app_bar_product.dart';
import 'package:ecommerce_app/widgets/carousel_product.dart';
import 'package:ecommerce_app/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReviewProvider>(
        context,
        listen: false,
      ).loadReviews(widget.productModel.id!);

      Provider.of<RatingProvider>(context, listen: false).loadRatings(widget.productModel.id!);
    });
  }

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final ratingProvider = Provider.of<RatingProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final ratings = ratingProvider.rating;
    final reviews = reviewProvider.review;

    return Scaffold(
      appBar: AppBarProductHelper(categoryName: "Laptop",), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselProduct(key: ValueKey(productVariant?.carousel ?? widget.productModel.images),imagePaths: (productVariant != null && productVariant!.carousel != null && productVariant!.carousel!.isNotEmpty)
    ? productVariant!.carousel!
    : (widget.productModel.images ?? []),),
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
                            quantity = 1;
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
                              print("Product Variant: $productVariant");
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
                  if(reviewProvider.isLoading)
                    Center(child: const SizedBox( width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),)) 
                  else
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
                              ...reviews!.map((item) => _reviewCard(time: item.createdDate!, comment: item.message!)).toList(),
                          
                              SizedBox(height: 8),
                          
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController _reviewController = TextEditingController();

                                      return AlertDialog(
                                        title: Text("Write Your Review"),
                                        content: TextField(
                                          controller: _reviewController,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            hintText: "Enter your comment here",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String review = _reviewController.text;
                                              print(review);
                                              if (review.isNotEmpty) {
                                                final message = await reviewProvider.addReview(widget.productModel.id!, review);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(message)),
                                                );
                                              }
                                            },
                                            child: Text("Submit"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "+ Write Your Review",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                          
                              SizedBox(height: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if(ratingProvider.isLoading)
                    Center(child: const SizedBox( width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),)) 
                  else 
                    ExpansionTileTheme(
                      data: ExpansionTileTheme.of(context).copyWith(
                        shape: Border(),
                        collapsedShape: Border()
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        initiallyExpanded: true,
                        title: Text("Ratings", style: TextStyle(fontWeight: FontWeight.w500)),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ...ratings!.map((item) => _ratingCard(imageUrl: item.imageUrl!,time: item.createdDate!, rating: item.rating!, comment: item.message!, name: item.name!)).toList(),
                          
                              SizedBox(height: 8),
                          
                              if(userProvider.user != null)
                                GestureDetector(
                                  onTap: () {
                                    double _currentRating = 5.0;
                                    TextEditingController _commentController = TextEditingController();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text("Write Your Rating"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("Your Rating: ${_currentRating.toStringAsFixed(1)}"),
                                                      Icon(Icons.star, color: Colors.amber)
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: _currentRating,
                                                    min: 0,
                                                    max: 5,
                                                    divisions: 10,
                                                    label: _currentRating.toStringAsFixed(1),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _currentRating = value;
                                                      });
                                                    },
                                                  ),
                                                  TextField(
                                                    controller: _commentController,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      hintText: "Enter your comment",
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    String comment = _commentController.text;
                                                    if (comment.isNotEmpty) {
                                                      final message = await ratingProvider.addRating(widget.productModel.id!, comment, _currentRating);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text(message)),
                                                      );
                                                    }
                                                  },
                                                  child: Text("Submit"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "+ Write Your Rating",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
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
        child: GestureDetector(
          onTap: cartProvider.isLoading ? null : () async {
            String? color = productVariant == null ? widget.productModel.color : productVariant?.color;
            String message = await cartProvider.addProductToCart(widget.productModel.id!, color!, quantity);
            if(cartProvider.errorMessage.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(cartProvider.errorMessage)),
              );
            }
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1C2F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: cartProvider.isLoading ?  
            Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ) :
            Row(
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
  required DateTime time,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: ${time.toLocal().toShortString()}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(comment, style: TextStyle(color: Colors.black)),
      ],
    ),
  );
}

Widget _ratingCard({
  required String imageUrl,
  required String name,
  required DateTime time,
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
               backgroundImage: imageUrl != "" ? NetworkImage(imageUrl) : NetworkImage("https://cdn-icons-png.flaticon.com/512/6596/6596121.png"),
             ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Date: ${time.toLocal().toShortString()}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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

extension DateFormatExtension on DateTime {
  String toShortString() {
    return '${this.day}/${this.month}/${this.year} - ${this.hour}:${this.minute}';
  }
}