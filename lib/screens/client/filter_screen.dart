import 'package:ecommerce_app/screens/client/product_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {

  final String categoryId;
  

  const FilterScreen({super.key, required this.categoryId});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int selectedTab = 0;
  String selectedSortOption = '1';
  List<String> selectedBrands = [];
  bool isAllSelected = false;

  final List<String> tabs = ['Sort by', 'Brand', 'Price', 'Rating'];

  final List<String> sortOptions = [
    'Name(A -> Z)',
    'Name(Z -> A)',
    'Price Ascending',
    'Price Descending',
    'Best Discount',
    'Newest',
  ];

  final List<String> brands = [
    'ASUS',
    'HP',
    'MSI',
    'Apple',
    'Acer',
    'Lenovo',
    'Gigabyte',
    'LG Gram'
  ];

  RangeValues priceRange = const RangeValues(0, 100000000);

  RangeValues ratingRange = const RangeValues(0.0, 5.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        leading: BackButton(),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Container(
            width: 100,
            color: const Color.fromRGBO(245, 245, 245, 1),
            child: ListView.separated(
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final isSelected = selectedTab == index;
                return ListTile(
                  title: Text(
                    tabs[index],
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.white,
                  onTap: () {
                    setState(() => selectedTab = index);
                  },
                );
              },
              separatorBuilder:
                  (context, index) => Divider(
                    color: Colors.grey.shade500,
                    height: 1,
                    thickness: 0.5,
                  ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (_) {
                  if (selectedTab == 0) {
                    return ListView(
                      children:
                          sortOptions.asMap().entries.map(
                                (option) => RadioListTile<String>(
                                  title: Text(option.value),
                                  value: (option.key + 1).toString(),
                                  groupValue: selectedSortOption,
                                  onChanged: (value) {
                                    setState(() => selectedSortOption = value!);
                                  },
                                ),
                              )
                              .toList(),
                    );
                  } else if (selectedTab == 1) {
                    return ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: CheckboxListTile(
                            value: isAllSelected,
                            title: const Text("All"),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              setState(() {
                                isAllSelected = value!;
                                selectedBrands =
                                    isAllSelected
                                        ? List.from(brands)
                                        : [];
                              });
                            },
                          ),
                        ),
                        ...brands.map((item) {
                          bool isChecked = selectedBrands.contains(
                            item,
                          );
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade100,
                            ),
                            child: CheckboxListTile(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedBrands.add(item);
                                  } else {
                                    selectedBrands.remove(item);
                                  }
                                  isAllSelected =
                                      selectedBrands.length == brands.length;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(item)
                            ),
                          );
                        }),
                      ],
                    );
                  }
                  else if(selectedTab == 2) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price Range',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_formatCurrency(priceRange.start.toDouble())}đ'),
                            Text('${_formatCurrency(priceRange.end.toDouble())}đ'),
                          ],
                        ),
                        RangeSlider(
                          values: priceRange,
                          min: 0,
                          max: 100000000,
                          divisions: 20,
                          activeColor: Colors.black87,
                          inactiveColor: Colors.black26,
                          labels: RangeLabels(
                            '${_formatCurrency(priceRange.start.toDouble())}đ',
                            '${_formatCurrency(priceRange.end.toDouble())}đ',
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              priceRange = values;
                            });
                          },
                        ),
                      ],
                    );
                  }
                  else if(selectedTab == 3) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rating Range',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(ratingRange.start.toStringAsFixed(1)),
                                const SizedBox(width: 4),
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                              ],
                            ),
                            Row(
                              children: [
                                Text(ratingRange.end.toStringAsFixed(1)),
                                const SizedBox(width: 4),
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                              ],
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: ratingRange,
                          min: 0.0,
                          max: 5.0,
                          divisions: 50,
                          activeColor: Colors.black87,
                          inactiveColor: Colors.black26,
                          labels: RangeLabels(
                            ratingRange.start.toStringAsFixed(1),
                            ratingRange.end.toStringAsFixed(1),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              ratingRange = values;
                            });
                          },
                        ),
                      ],
                    );
                  }
                  else {
                    return const Center(child: Text('Other filters coming soon...'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedTab = 0;
                    selectedSortOption = '1';
                    selectedBrands = [];
                    priceRange = const RangeValues(0, 100000000);
                    ratingRange = const RangeValues(0.0, 5.0);
                  });
                },
                child: const Text('Reset All'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPageScreen(categoryId: widget.categoryId, sortById: selectedSortOption, brandSelection: selectedBrands, priceRangeStart: priceRange.start, priceRangeEnd: priceRange.end, ratingRangeStart: ratingRange.start, ratingRangeEnd: ratingRange.end,)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatCurrency(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}
