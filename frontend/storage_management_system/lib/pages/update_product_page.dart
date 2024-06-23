import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_system/models/product.dart';
import 'package:storage_management_system/services/api_service.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;

  UpdateProductPage({required this.product});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  String? _selectedCategory;
  String? _updatedBy;
  File? _imageFile;
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _qtyController.text = widget.product.qty.toString();
    _selectedCategory = widget.product.categoryId.toString();
    _loadUser();
    _loadCategories();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState(() {
      _updatedBy = username ?? 'Unknown User';
      print('Loaded username: $_updatedBy'); // Debugging output
    });

    if (_updatedBy == null) {
      print(
          'Error: username not found in SharedPreferences'); // Debugging output
    }
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _qtyController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category['id'].toString(),
                      child: Text(category['name']),
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
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select Image'),
                ),
                if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    height: 100,
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_updatedBy == null) {
                        print('Error: updatedBy is null');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Error: username not found, cannot update product'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        await ApiService.updateProduct(
                          widget.product.id.toString(),
                          {
                            'name': _nameController.text,
                            'qty': int.parse(_qtyController.text),
                            'categoryId': int.parse(_selectedCategory!),
                            'updatedBy': _updatedBy,
                          },
                          _imageFile,
                        );
                        Navigator.pop(context,
                            true); // Return true to indicate successful update
                      } catch (e) {
                        print('Error updating product: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update product: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
