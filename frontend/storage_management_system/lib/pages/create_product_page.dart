import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_system/services/api_service.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  String? _selectedCategory;
  String? _createdBy;
  File? _imageFile;
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCategories();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState(() {
      _createdBy = username ?? ' --- ';
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

      print('MIME type: ${_imageFile!.path.split('.').last}');
    }
  }

  bool _isValidImageType(String path) {
    final validTypes = ['jpg', 'jpeg', 'png'];
    final fileType = path.split('.').last.toLowerCase();
    return validTypes.contains(fileType);
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _qtyController.clear();
      _selectedCategory = null;
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // no shadow
        toolbarHeight: 50, // adjust height as needed
      ),
      body: Padding(
        padding:
            const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0), // top padding added
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Create New Product',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  shrinkWrap: true,
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
                      initialValue: _createdBy ?? ' --- ',
                      decoration: InputDecoration(
                        labelText: 'Created By',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pick Product Image'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green, // foreground color
                      ),
                    ),
                    SizedBox(height: 16.0),
                    if (_imageFile != null)
                      Image.file(
                        _imageFile!,
                        height: 50,
                      ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          int? categoryId;

                          try {
                            categoryId = int.parse(_selectedCategory!);
                          } catch (e) {
                            print('Error parsing value: $e');
                            return;
                          }

                          final productData = {
                            'name': _nameController.text,
                            'qty': _qtyController.text,
                            'categoryId': categoryId,
                            'createdBy': _createdBy,
                          };

                          var response;
                          try {
                            response = await ApiService.createProduct(
                                productData, _imageFile);
                            print('Product data: $productData');
                            print(
                                'Response status code: ${response.statusCode}');
                            print('Response data: ${response.data}');
                          } catch (e) {
                            print('Error creating product: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to create product: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (response.statusCode == 201) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Product created successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            _resetForm(); // Reset the form after successful creation
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to create product: ${response.data}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Create Product'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green, // foreground color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
