import 'package:flutter/material.dart';
import 'package:storage_management_system/util/categories.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _nameState();
}

class _nameState extends State<ProductPage> {
  // Tabs category
  final List<Widget> categories = [
    // All Categories
    Categories(
      iconPath: 'lib/icons/monitor.png',
    ),
    Categories(
      iconPath: 'lib/icons/laptop.png',
    ),
    Categories(
      iconPath: 'lib/icons/keyboard.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.grey[800],
                  size: 36,
                ),
                onPressed: () {
                  //open drawer
                }),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.grey[800],
                  size: 50,
                ),
                onPressed: () {
                  //Profile button tapped
                },
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
              child: Row(
                children: const [
                  Text(
                    "I want to eat",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    " EAT",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Tab Bar category
            TabBar(tabs: categories),
            // Tab bar view
          ],
        ),
      ),
    );
  }
}
