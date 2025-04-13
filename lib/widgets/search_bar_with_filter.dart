import 'package:ecommerce_app/screens/client/filter_screen.dart';
import 'package:flutter/material.dart';

class SearchBarWithFilter extends StatelessWidget {

  final String categoryId;
  final String categoryName;
  final Function(String)? onSearchChanged;

  const SearchBarWithFilter({super.key, required this.categoryId, required this.categoryName, this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => FilterScreen(categoryId: categoryId, categoryName: categoryName,)),
              );
            }, 
            icon: const Icon(Icons.tune)
          ),
        ),
      ],
    );
  }
}