import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: Column(
            children: [
              product.urlImage != null
                  ? Image.network(
                      'http://192.168.116.138:4000${product.urlImage}')
                  : Icon(Icons.image),
              Text(product.name),
              Text('Qty: ${product.qty}'),
              ElevatedButton(
                child: Text('Add to Cart'),
                onPressed: () {
                  // Add to cart button pressed
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
