import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final String iconPath;
  const Categories({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 80,
      child: Image.asset(
        iconPath,
        color: Colors.grey[600],
      ),
    );
  }
}
