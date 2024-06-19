import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProductPage extends StatefulWidget {
  final Map<String, dynamic> initialData;

  UpdateProductPage({Key? key, required this.initialData}) : super(key: key);

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  String? _selectedCategory;
  String? _imageUrl;
  String? _updatedBy; // Untuk menyimpan updatedBy user_id

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Home Appliances',
    'Books',
    'Others'
  ]; // Contoh kategori

  @override
  void initState() {
    super.initState();
    _loadUser(); // Memuat informasi pengguna saat widget diinisialisasi
    _loadProductData(); // Memuat data produk yang sudah ada untuk diupdate
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _updatedBy = prefs.getString('username') ??
          'Unknown User'; // Mengambil username sebagai updatedBy
    });
  }

  void _loadProductData() {
    _nameController.text = widget.initialData['name'] ?? '';
    _qtyController.text = widget.initialData['qty']?.toString() ?? '';
    _selectedCategory = widget.initialData['category'] ?? _categories[0];
    _imageUrl = widget.initialData['imageUrl'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                initialValue: _updatedBy,
                decoration: InputDecoration(
                  labelText: 'Updated By',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Fungsi untuk memilih gambar dan mengatur _imageUrl
                  // Ini harus membuka file picker atau image picker
                },
                child: Text('Pick Product Image'),
              ),
              SizedBox(height: 16.0),
              if (_imageUrl != null && _imageUrl!.isNotEmpty)
                Image.network(
                  _imageUrl!,
                  height: 100,
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Memproses pengiriman formulir
                    final updatedProductData = {
                      'name': _nameController.text,
                      'qty': int.parse(_qtyController.text),
                      'category': _selectedCategory,
                      'imageUrl': _imageUrl ?? '',
                      'updatedBy': _updatedBy,
                    };

                    // Kirim updatedProductData ke backend Anda
                    print(updatedProductData);
                  }
                },
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UpdateProductPage(
      initialData: {
        'name': 'Initial Product Name',
        'qty': 10,
        'category': 'Electronics',
        'imageUrl': 'https://example.com/image.jpg',
      },
    ),
  ));
}
