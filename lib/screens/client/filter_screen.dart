import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int selectedTab = 0;
  String selectedSortOption = 'Relevance';
  List<String> selectedColors = [];
  bool isAllSelected = false;

  final List<String> tabs = ['Sort by', 'Color', 'Price', 'Rating'];

  final List<String> sortOptions = [
    'Name(A -> Z)',
    'Name(Z -> A)',
    'Price Ascending',
    'Price Descending',
    'Best Discount'
        'Newest',
  ];

  final List<Map<String, dynamic>> colors = [
    {"name": "Black", "color": Colors.black, "count": 5},
    {"name": "Gray", "color": Colors.grey, "count": 12},
    {"name": "Blue", "color": Colors.blue, "count": 22},
    {"name": "Yellow", "color": Colors.yellow, "count": 6},
    {"name": "Green", "color": Colors.green, "count": 10},
    {"name": "Red", "color": Colors.red, "count": 8},
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
                          sortOptions
                              .map(
                                (option) => RadioListTile<String>(
                                  title: Text(option),
                                  value: option,
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
                            title: const Text("Select All"),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              setState(() {
                                isAllSelected = value!;
                                selectedColors =
                                    isAllSelected
                                        ? colors
                                            .map((c) => c["name"] as String)
                                            .toList()
                                        : [];
                              });
                            },
                          ),
                        ),
                        ...colors.map((item) {
                          bool isChecked = selectedColors.contains(
                            item["name"],
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
                                    selectedColors.add(item["name"]);
                                  } else {
                                    selectedColors.remove(item["name"]);
                                  }
                                  isAllSelected =
                                      selectedColors.length == colors.length;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: item["color"],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  Text(item["name"]),
                                ],
                              ),
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
                  setState(() => selectedSortOption = 'Relevance');
                },
                child: const Text('Reset All'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedSortOption);
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
