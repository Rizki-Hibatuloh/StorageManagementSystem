import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryBar extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final ValueChanged<Category> onCategorySelected;

  CategoryBar({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: selectedCategory == category.name
                    ? Colors.blue
                    : Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                category.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
