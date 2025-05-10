import 'package:ecommerce_app/providers/category_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategory();
    });
  }

  @override
Widget build(BuildContext context) {

  final categoryProvider = Provider.of<CategoryProvider>(context);
  int selectedIndex = categoryProvider.selectedCategoryIndex;

  return Consumer<CategoryProvider>(
    builder: (context, categoryProvider, child) {

      if (categoryProvider.categories.isEmpty) {
        return Center(child: CircularProgressIndicator()); 
      }

      return SizedBox(
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categoryProvider.categories.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ChoiceChip(
                  key: ValueKey(categoryProvider.categories[index].id),
                  label: Text(
                    categoryProvider.categories[index].name,
                    style: TextStyle(
                      color: selectedIndex == index ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: selectedIndex == index,
                  selectedColor: Colors.blue,
                  onSelected: (bool selected) {
                    categoryProvider.setSelectedCategoryIndex(index);
                    categoryProvider.getStatus(context, categoryProvider.categories[index]);
                    categoryProvider.getStatus(context, categoryProvider.categories[index]);
                  },
                ),
              );
            }),
          ),
        ),
      );
    },
  );
}
}
