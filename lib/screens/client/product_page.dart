import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/category_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/widgets/app_bar_category.dart';
import 'package:ecommerce_app/widgets/app_bar_home.dart';
import 'package:ecommerce_app/widgets/app_bar_product.dart';
import 'package:ecommerce_app/widgets/carousel.dart';
import 'package:ecommerce_app/widgets/category_selector.dart';
import 'package:ecommerce_app/widgets/home_drawer.dart';
import 'package:ecommerce_app/widgets/product_grid.dart';
import 'package:ecommerce_app/widgets/product_grid_lazy.dart';
import 'package:ecommerce_app/widgets/product_item.dart';
import 'package:ecommerce_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPageScreen extends StatefulWidget {

  final String categoryId;
  final String categoryName;

  const ProductPageScreen({super.key, required this.categoryId, required this.categoryName});
  
  @override
  _ProductScreenState createState() => _ProductScreenState();

}

class _ProductScreenState extends State<ProductPageScreen> {

@override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      await productProvider.getAllProductPages(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductProvider>(context);  
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBarProductHelper(categoryName: widget.categoryName,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(),
            SizedBox(height: 20),
            if ((productProvider.productsByCategory[widget.categoryId] ?? []).isEmpty && productProvider.isLoading) 
                Center(child: CircularProgressIndicator())
              else if ((productProvider.productsByCategory[widget.categoryId] ?? []).isEmpty)
                Center(child: Text("Không có sản phẩm nào 😢"))
              else
                Expanded(child: ProductGridLazy(products: (productProvider.productsByCategory[widget.categoryId] ?? []))),
          ],
        ),
      ),
    );
  }
}


