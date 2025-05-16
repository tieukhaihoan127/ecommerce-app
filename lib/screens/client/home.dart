import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/category_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/screens/client/product_page.dart';
import 'package:ecommerce_app/widgets/app_bar_home.dart';
import 'package:ecommerce_app/widgets/carousel.dart';
import 'package:ecommerce_app/widgets/category_selector.dart';
import 'package:ecommerce_app/widgets/home_drawer.dart';
import 'package:ecommerce_app/widgets/product_grid.dart';
import 'package:ecommerce_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  bool _isLoaded = false;

  final List<String> imagePaths = [
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1747407473/m7urNdoR9p_1_ncye7h.png",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1747407474/xFnoYWvpVr_flczar.png",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1747407476/0ig4QkXL2p_pawttd.png",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1747407480/cPnnUWYUC9_y5jeq8.png"
  ];

@override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      if (!_isLoaded) {
        String? status = categoryProvider.status;
        await categoryProvider.loadCategory();
        if (status != "All") {
          await productProvider.getAllProducts(status);
        } else {
          List<Future> futures = [];
          for (var category in categoryProvider.categories) {
            if (!productProvider.productsHomeByCategory.containsKey(category.id)) {
              futures.add(productProvider.getAllProducts(category.id));
            }
          }
          await Future.wait(futures);
        }
        setState(() {
          _isLoaded = true; 
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);    
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBarHome(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: categoryProvider.status == "All" ? 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Carousel(imagePaths: imagePaths),
              SizedBox(height: 20),
              CategorySelector(),
              SizedBox(height: 20),
              ...categoryProvider.categories.skip(1).map((category){
                List<ProductModel> productsForCategory = productProvider.productsHomeByCategory[category.id] ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Categories(text: category.name, categoryId: category.id,),
                    SizedBox(height: 10),
                    if (productsForCategory.isEmpty && productProvider.isLoading) 
                      Center(child: CircularProgressIndicator())
                    else if (productsForCategory.isEmpty)
                      Center(child: Text("Không có sản phẩm nào 😢"))
                    else
                      ProductGrid(products: productsForCategory),
                    SizedBox(height: 20),
                  ],
                );
              })
            ],
          ) :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Carousel(imagePaths: imagePaths),
              SizedBox(height: 20),
              CategorySelector(),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Categories(text: categoryProvider.name, categoryId: categoryProvider.status,),
                  SizedBox(height: 10),
                  if ((productProvider.productsHomeByCategory[categoryProvider.status] ?? []).isEmpty && productProvider.isLoading) 
                      Center(child: CircularProgressIndicator())
                    else if ((productProvider.productsHomeByCategory[categoryProvider.status] ?? []).isEmpty)
                      Center(child: Text("Không có sản phẩm nào 😢"))
                    else...[
                      ProductGrid(products: (productProvider.productsHomeByCategory[categoryProvider.status] ?? [])),
                    ],
                    
                    SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {

  final String text;
  final String categoryId;

  const Categories({super.key,required this.text, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPageScreen(categoryId: categoryId)));
          },
          child: Text(
            "View All",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          ),
        )
      ],
    );
  }
}
