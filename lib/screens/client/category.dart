import 'package:ecommerce_app/providers/category_provider.dart';
import 'package:ecommerce_app/screens/client/product_page.dart';
import 'package:ecommerce_app/widgets/app_bar_category.dart';
import 'package:ecommerce_app/widgets/category_card.dart';
import 'package:ecommerce_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).fetchAllCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBarCategoryHelper(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBarWidget(),
            const SizedBox(height: 16),
            
            if (categoryProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (categoryProvider.categoryPages.isEmpty)
              const Center(child: Text("Không có danh mục nào 😢"))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: categoryProvider.categoryPages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPageScreen(categoryId: categoryProvider.categoryPages[index].id, categoryName: categoryProvider.categoryPages[index].name)));
                          },
                          child: CategoryCard(
                            name: categoryProvider.categoryPages[index].name!,
                            imageUrl: categoryProvider.categoryPages[index].imageUrl!,
                            productCount: categoryProvider.categoryPages[index].productCount!,
                          ),
                        ),
                        const SizedBox(height: 12,)
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}