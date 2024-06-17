import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> _products = [];
  List<Product> _cartProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final apiService = ApiService();
    final products = await apiService.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search button pressed
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Menu button pressed
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ProductItem(
            product: _products[index],
            onAddToCart: () {
              setState(() {
                _cartProducts.add(_products[index]);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show cart
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartPage(cartProducts: _cartProducts)),
          );
        },
        tooltip: 'Cart',
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  ProductItem({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(product.image),
          Text(product.name),
          Text(product.price),
          ElevatedButton(
            child: Icon(Icons.add_shopping_cart),
            onPressed: onAddToCart,
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cartProducts;

  CartPage({required this.cartProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Text(cartProducts[index].name),
                Text(cartProducts[index].price),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ApiService {
  Future<List<Product>> getAllProducts() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    return [
      Product(
        id: 1,
        image: 'assets/sneakers.jpg',
        name: 'Nike Air Max 270',
        price: '\$150',
      ),
      Product(
        id: 2,
        image: 'assets/sneakers.jpg',
        name: 'Adidas Yeezy Boost 350',
        price: '\$200',
      ),
      Product(
        id: 3,
        image: 'assets/sneakers.jpg',
        name: 'Jordan 1 Retro High OG',
        price: '\$180',
      ),
    ];
  }
}

class Product {
  final int id;
  final String image;
  final String name;
  final String price;

  Product(
      {required this.id,
      required this.image,
      required this.name,
      required this.price});
}
