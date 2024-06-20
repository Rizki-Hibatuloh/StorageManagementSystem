import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_system/pages/create_product_page.dart';
import 'package:storage_management_system/pages/login_page.dart';
import 'package:storage_management_system/pages/update_product_page.dart';
import 'package:storage_management_system/services/api_service.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? username;
  String? profilePicture;
  List<dynamic> _categories = []; // List untuk menyimpan kategori produk
  TextEditingController _searchController = TextEditingController();
  dynamic _searchedProduct;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCategories(); // Panggil fungsi untuk memuat kategori
  }

  // Fungsi untuk memuat data pengguna dari SharedPreferences
  void _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      profilePicture = prefs.getString('profilePicture');
    });
  }

  // Fungsi untuk memuat kategori dari API
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

  // Fungsi untuk logout dan menghapus data pengguna dari SharedPreferences
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Fungsi untuk mencari produk berdasarkan ID
  Future<void> _searchProductById(String productId) async {
    try {
      dynamic product = await ApiService.getProductById(productId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 247, 203, 138),
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
              leading: Icon(Icons.person, color: Colors.blueGrey),
              title: Text('Profile', style: TextStyle(color: Colors.blueGrey)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.create, color: Colors.blueGrey),
              title: Text('Create Product',
                  style: TextStyle(color: Colors.blueGrey)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProductPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blueGrey),
              title: Text('Logout', style: TextStyle(color: Colors.blueGrey)),
              onTap: () {
                _logout();
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: _categories.length + 1, // Jumlah tab termasuk "All"
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 236, 231, 222),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username ?? '',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[300],
                      ),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu, color: Colors.deepOrange[300]),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Jarak antara header dan judul kategori
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
                  hintText: 'Search by Product ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
            if (_searchedProduct == null && _searchController.text.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('No product found with the given ID.'),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  8.5, 15, 8.5, 8), // Padding untuk TabBar
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300], // Warna background untuk TabBar
                ),
                child: TabBar(
                  isScrollable: true, // Biarkan tab dapat di-scroll jika banyak
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        Colors.deepOrange[300], // Warna untuk tab yang dipilih
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tab(text: 'All'),
                    ), // Tab baru untuk menampilkan semua produk
                    ..._categories.map<Widget>((category) {
                      return Tab(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text(category['name']),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Widget untuk menampilkan semua produk
                  _buildAllProductsView(),

                  // Widget untuk masing-masing kategori
                  ..._categories.map<Widget>((category) {
                    return _buildCategoryProductsView(category['id']);
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan semua produk
  Widget _buildAllProductsView() {
    return FutureBuilder<List<dynamic>>(
      future:
          ApiService.getAllProducts(), // Metode untuk mendapatkan semua produk
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2 / 3, // Set aspect ratio sesuai kebutuhan
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
                                  'http://192.168.228.138:4000${products[index]['urlImage']}',
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index]['name'] ?? '',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Stock: ${products[index]['stock']}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueGrey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProductPage(
                              product: products[index],
                            ),
                          ),
                        );
                      },
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

  // Widget untuk menampilkan produk berdasarkan kategori
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
              childAspectRatio: 2 / 3, // Set aspect ratio sesuai kebutuhan
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
                                  'http://192.168.228.138:4000${products[index]['urlImage']}',
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index]['name'] ?? '',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Stock: ${products[index]['stock']}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueGrey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProductPage(
                              product: products[index],
                            ),
                          ),
                        );
                      },
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

  // Widget untuk menampilkan hasil pencarian produk
  Widget _buildSearchedProductView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _searchedProduct['urlImage'] != null
                      ? Image.network(
                          'http://192.168.228.138:4000${_searchedProduct['urlImage']}',
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _searchedProduct['name'] ?? '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Stock: ${_searchedProduct['stock']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueGrey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProductPage(
                      product: _searchedProduct,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
