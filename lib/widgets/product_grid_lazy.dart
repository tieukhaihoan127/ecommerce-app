import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/client/product_detail_page.dart';
import 'package:ecommerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';

class ProductGridLazy extends StatefulWidget {
  final List<ProductModel> products;

  const ProductGridLazy({super.key, required this.products});

  @override
  _ProductGridLazyState createState() => _ProductGridLazyState();
}

class _ProductGridLazyState extends State<ProductGridLazy> {
  final ScrollController _scrollController = ScrollController();
  List<ProductModel> _displayedProducts = [];
  int _currentMax = 6;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;

      setState(() {
        _currentMax = screenWidth >= 1000 ? 4 : 6;
        _displayedProducts = widget.products.take(_currentMax).toList();
      });

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
          _loadMore();
        }
      });
    });
  }

  void _loadMore() {
    if (_currentMax >= widget.products.length) return;

    setState(() {
      int nextMax = _currentMax + 4;
      if (nextMax > widget.products.length) nextMax = widget.products.length;

      _displayedProducts = widget.products.take(nextMax).toList();
      _currentMax = nextMax;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _getCrossAxisCount(BoxConstraints constraints) {
    if (constraints.maxWidth >= 1000) return 4;
    if (constraints.maxWidth >= 600) return 3;
    return 2;
  }

  double _getAspectRatio(BoxConstraints constraints) {
    if (constraints.maxWidth >= 1000) return 0.8;
    if (constraints.maxWidth >= 600) return 0.7;
    return 0.65;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints);
        final aspectRatio = _getAspectRatio(constraints);

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          itemCount: _currentMax < widget.products.length
              ? _displayedProducts.length + 1
              : _displayedProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (index == _displayedProducts.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _currentMax < widget.products.length
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Đã xem hết tất cả sản phẩm!!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                ),
              );
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(
                      productModel: _displayedProducts[index],
                    ),
                  ),
                );
              },
              child: ProductItem(product: _displayedProducts[index]),
            );
          },
        );
      },
    );
  }
}
