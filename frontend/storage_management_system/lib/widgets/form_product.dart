import 'package:flutter/material.dart';

class FormProduct extends StatefulWidget {
  final bool isCreate;
  final Map<String, dynamic>? initialData;

  FormProduct({Key? key, required this.isCreate, this.initialData})
      : super(key: key);

  @override
  _FormProductState createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  String? _selectedCategory;
  String? _createdBy;
  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Home Appliances',
    'Books',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
    if (!widget.isCreate && widget.initialData != null) {
      _loadProductData();
    }
  }

  void _loadUser() {
    // Load user data logic
    _createdBy = 'User123'; // Example hardcoded user id
  }

  void _loadProductData() {
    // Load product data logic based on widget.initialData
    _nameController.text = widget.initialData!['name'] ?? '';
    _qtyController.text = widget.initialData!['qty']?.toString() ?? '0';
    _selectedCategory = widget.initialData!['category'] ?? _categories[0];
    // Load other fields as needed
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          if (!widget.isCreate) ...[
            TextFormField(
              enabled: false,
              initialValue: _createdBy,
              decoration: InputDecoration(
                labelText: 'Created By',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
          ],
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
            items: _categories
                .map((category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final productData = {
                  'name': _nameController.text,
                  'qty': int.parse(_qtyController.text),
                  'category': _selectedCategory,
                  'createdBy': _createdBy,
                };
                print(productData);
              }
            },
            child: Text(widget.isCreate ? 'Create Product' : 'Update Product'),
          ),
        ],
      ),
    );
  }
}
