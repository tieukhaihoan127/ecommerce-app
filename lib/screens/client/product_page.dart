import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/widgets/app_bar_product.dart';
import 'package:ecommerce_app/widgets/home_drawer.dart';
import 'package:ecommerce_app/widgets/product_grid_lazy.dart';
import 'package:ecommerce_app/widgets/search_bar_with_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPageScreen extends StatefulWidget {
  final String categoryId;
  final String? sortById;
  final List<String>? brandSelection;
  final double? priceRangeStart;
  final double? priceRangeEnd;
  final double? ratingRangeStart;
  final double? ratingRangeEnd;

  const ProductPageScreen({
    super.key,
    required this.categoryId,
    this.sortById,
    this.brandSelection,
    this.priceRangeStart,
    this.priceRangeEnd,
    this.ratingRangeStart,
    this.ratingRangeEnd,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductPageScreen> {
  String _searchQuery = "";

  void _handleSearchChanged(String value) async {
    setState(() {
      _searchQuery = value;
    });
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.clearProductsByCategory(widget.categoryId);
    await productProvider.getAllProductPages(
      widget.categoryId,
      widget.sortById ?? '1',
      widget.brandSelection,
      widget.priceRangeStart,
      widget.priceRangeEnd,
      widget.ratingRangeStart,
      widget.ratingRangeEnd,
      _searchQuery,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.clearProductsByCategory(widget.categoryId);
      await productProvider.getAllProductPages(
        widget.categoryId,
        widget.sortById ?? '1',
        widget.brandSelection,
        widget.priceRangeStart,
        widget.priceRangeEnd,
        widget.ratingRangeStart,
        widget.ratingRangeEnd,
        "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBarProductHelper(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarWithFilter(
                  categoryId: widget.categoryId,
                  onSearchChanged: _handleSearchChanged,
                ),
                const SizedBox(height: 20),
                if ((productProvider.productsByCategory[widget.categoryId] ?? []).isEmpty &&
                    productProvider.isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if ((productProvider.productsByCategory[widget.categoryId] ?? []).isEmpty)
                  const Expanded(child: Center(child: Text("Không có sản phẩm nào 😢")))
                else
                  Expanded(
                    child: ProductGridLazy(
                      products: productProvider.productsByCategory[widget.categoryId] ?? [],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
