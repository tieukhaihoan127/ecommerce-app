import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/category_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
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
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385905/samples/balloons.jpg",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385910/samples/cup-on-a-table.jpg",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385910/samples/chair-and-coffee-table.jpg",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385905/samples/shoe.jpg"
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
            if (!productProvider.productsByCategory.containsKey(category.id)) {
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
              SearchBarWidget(),
              SizedBox(height: 20),
              Carousel(imagePaths: imagePaths),
              SizedBox(height: 20),
              CategorySelector(),
              SizedBox(height: 20),
              ...categoryProvider.categories.map((category){
                List<ProductModel> productsForCategory = productProvider.productsByCategory[category.id] ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Categories(text: category.name),
                    SizedBox(height: 10),
                    // Consumer<ProductProvider>(
                    //   builder: (context, productProvider, child) {
                    //     if (productProvider.isLoading) {
                    //       return Center(child: CircularProgressIndicator());
                    //     } 
                    //     if (productProvider.products.isEmpty) {
                    //       return Center(child: Text("Không có sản phẩm nào 😢"));
                    //     }
                    //     return ProductGrid(products: productProvider.products);
                    //   },
                    // ),
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
              SearchBarWidget(),
              SizedBox(height: 20),
              Carousel(imagePaths: imagePaths),
              SizedBox(height: 20),
              CategorySelector(),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Categories(text: categoryProvider.name),
                  SizedBox(height: 10),
                  if ((productProvider.productsByCategory[categoryProvider.status] ?? []).isEmpty && productProvider.isLoading) 
                      Center(child: CircularProgressIndicator())
                    else if ((productProvider.productsByCategory[categoryProvider.status] ?? []).isEmpty)
                      Center(child: Text("Không có sản phẩm nào 😢"))
                    else
                      ProductGrid(products: (productProvider.productsByCategory[categoryProvider.status] ?? [])),
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


// class CategorySelector extends StatelessWidget {
//   final List<String> categories = ['All', 'Promotional Products', 'New Products', 'Best Sellers', 'Laptops','Monitors','Keyboards','Mouses','Hard Drives','Webcams'];
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: categories
//               .map((category) => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                     child: Chip(label: Text(category)),
//                   ))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }

class Categories extends StatelessWidget {

  final String text;

  const Categories({super.key,required this.text});

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

// class ProductGrid extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.7,
//         mainAxisSpacing: 5.0,
//         crossAxisSpacing: 5.0,
//       ),
//       itemCount: 4,
//       itemBuilder: (context, index) {
//         return ProductCard();
//       },
//     );
//   }
// }
