import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_system/services/api_service.dart';
import 'package:storage_management_system/models/product.dart'; // Sesuaikan dengan path yang benar

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
  int? _createdBy;
  File? _imageFile;
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCategories();
    _initializeForm();
  }

  void _initializeForm() {
    _nameController.text = widget.product.name;
    _qtyController.text = widget.product.qty.toString();
    _selectedCategory = widget.product.categoryId.toString();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    setState(() {
      _createdBy = userId ?? -1;
    });
  }

  void _loadCategories() async {
    try {
      List<dynamic> categories = await ApiService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (!_isValidImageType(pickedFile.path)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Invalid file type. Only jpg, png, and jpeg are allowed.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  bool _isValidImageType(String path) {
    final validTypes = ['jpg', 'jpeg', 'png'];
    final fileType = path.split('.').last.toLowerCase();
    return validTypes.contains(fileType);
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
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                initialValue: _createdBy?.toString() ?? 'Unknown User',
                decoration: InputDecoration(
                  labelText: 'Created By',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Product Image'),
              ),
              SizedBox(height: 16.0),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 100,
                )
              else if (widget.product.urlImage != null)
                Image.network(
                  widget.product.urlImage!,
                  height: 100,
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    int? categoryId;
                    int? createdBy;

                    try {
                      categoryId = int.parse(_selectedCategory!);
                      createdBy = _createdBy;
                    } catch (e) {
                      print('Error parsing value: $e');
                      return;
                    }

                    final productData = {
                      'name': _nameController.text,
                      'qty': _qtyController.text,
                      'categoryId': categoryId,
                      'createdBy': createdBy,
                    };

                    var response;
                    try {
                      response = await ApiService.updateProduct(
                          widget.product.id.toString(),
                          productData,
                          _imageFile);
                      print('Product data: $productData');
                      print('Response status code: ${response.statusCode}');
                      print('Response data: ${response.data}');
                    } catch (e) {
                      print('Error updating product: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update product: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to update product: ${response.data}'),
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
    );
  }
}
