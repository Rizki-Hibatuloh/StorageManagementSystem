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
      _updatedBy = username ?? '----';
    });

    if (_updatedBy == null) {
      print('Error: username not found in SharedPreferences');
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
      backgroundColor: Colors.blue[900], // Background color for the whole page
      appBar: AppBar(
        elevation: 0, // no shadow
        toolbarHeight: 50, // adjust height as needed
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding:
            const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0), // top padding added
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Update Product',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 24.0),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white, // Container background color
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  // Changed from ListView to Column
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Added to stretch children horizontally
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        labelStyle: TextStyle(
                            color: Colors
                                .blue[800]), // Set label text color to blue
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors.grey), // Set border color to grey
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .grey), // Set enabled border color to grey
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .blue), // Set focused border color to blue
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.blue[800]), // Set text color to blue
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
                        labelStyle: TextStyle(
                            color: Colors
                                .blue[800]), // Set label text color to blue
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors.grey), // Set border color to grey
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .grey), // Set enabled border color to grey
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .blue), // Set focused border color to blue
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.blue[800]), // Set text color to blue
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
                        labelStyle: TextStyle(
                            color: Colors
                                .blue[800]), // Set label text color to blue
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors.grey), // Set border color to grey
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .grey), // Set enabled border color to grey
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .blue), // Set focused border color to blue
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.blue[800]), // Set text color to blue
                      dropdownColor:
                          Colors.white, // Set dropdown menu background color
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category['id'].toString(),
                          child: Text(category['name'],
                              style: TextStyle(color: Colors.blue[800])),
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
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pick Product Image'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // Button background color
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
                          if (_updatedBy == null) {
                            print('Error: updatedBy is null');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error: username not found, cannot update product',
                                ),
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // Button background color
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
