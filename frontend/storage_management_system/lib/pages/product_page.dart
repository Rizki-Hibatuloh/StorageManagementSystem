import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_system/models/product.dart';
import 'package:storage_management_system/pages/create_product_page.dart';
import 'package:storage_management_system/pages/login_page.dart';
import 'package:storage_management_system/pages/update_product_page.dart';
import 'package:storage_management_system/services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.deepOrange[300],
        scaffoldBackgroundColor: Color.fromARGB(255, 236, 231, 222),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.deepOrange[300]),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blue[800],
        ),
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
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
  String? username;
  String? profilePicture;
  List<dynamic> _categories = [];
  TextEditingController _searchController = TextEditingController();
  Product? _searchedProduct;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCategories();
  }

  void _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      profilePicture = prefs.getString('image');
      print('Username: $username');
      print('Profile Picture URL: $profilePicture');
    });
  }

  void _loadCategories() async {
    try {
      List<dynamic> categories = await ApiService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<List<Product>> _fetchProducts() async {
    final response = await ApiService.getAllProducts();
    return response.map<Product>((json) => Product.fromJson(json)).toList();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _searchProductById(String productId) async {
    try {
      Product? product = await ApiService.getProductById(productId);
      setState(() {
        _searchedProduct = product;
      });
    } catch (e) {
      print('Error searching product: $e');
      setState(() {
        _searchedProduct = null;
      });
    }
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await ApiService.deleteProduct(productId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profilePicture != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePicture!),
                      radius: 40,
                    ),
                  if (profilePicture == null)
                    CircleAvatar(
                      child: Icon(Icons.person),
                      radius: 40,
                    ),
                  SizedBox(height: 8),
                  if (username != null)
                    Text(
                      username!,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Create Product'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProductPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: _categories.length + 1,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username ?? '',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Product by ID',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _searchProductById(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
            if (_searchedProduct != null) _buildSearchedProductView(),
            if (_searchedProduct == null)
              Expanded(
                child: Column(
                  children: [
                    TabBar(
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[400]!,
                            width: 2.0,
                          ),
                        ),
                      ),
                      tabs: [
                        Tab(
                          text: 'All',
                          icon: Icon(Icons.all_inclusive),
                        ),
                        for (var category in _categories)
                          Tab(text: category['name']),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildAllProductsView(),
                          for (var category in _categories)
                            _buildCategoryProductsView(category['id']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllProductsView() {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2 / 3,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(4.0)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: products[index]['urlImage'] != null
                              ? Image.network(
                                  'http://192.168.88.138:4000${products[index]['urlImage']}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Icon(Icons.image),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index]['name'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'qty: ${products[index]['qty']}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductPage(
                                  product: Product.fromJson(products[index]),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteProduct(products[index]['id']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCategoryProductsView(int categoryId) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getProductsByCategory(categoryId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2 / 3,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(4.0)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: products[index]['urlImage'] != null
                              ? Image.network(
                                  'http://192.168.88.138:4000${products[index]['urlImage']}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Icon(Icons.image),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index]['name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'qty: ${products[index]['qty']}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductPage(
                                  product: Product.fromJson(products[index]),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteProduct(products[index]['id']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildSearchedProductView() {
    if (_searchedProduct == null) {
      return Center(child: Text('No product found'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _searchedProduct!.urlImage != null
                  ? Image.network(
                      'http://192.168.88.138:4000${_searchedProduct!.urlImage}',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey,
                      child: Icon(Icons.image),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8), // Spacing above product name
                  Text(
                    _searchedProduct!.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1, // Ensure product name stays within bounds
                    overflow: TextOverflow.ellipsis, // Ellipsis if overflow
                  ),
                  SizedBox(height: 4), // Small spacing between name and qty
                  Text(
                    'qty: ${_searchedProduct!.qty}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8), // Spacing below qty text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProductPage(
                          product: _searchedProduct!,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteProduct(_searchedProduct!.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
