import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:storage_management_system/models/product.dart';

class ApiService {
  static final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://192.168.159.138:4000'));

  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get('http://192.168.159.138:4000/categories');
      return response.data;
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio
          .get('http://192.168.159.138:4000/products?category=$categoryId');
      return response.data;
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getAllProducts() async {
    try {
      final response = await _dio.get('http://192.168.159.138:4000/products');
      return response.data;
    } catch (e) {
      print('Error getting all products: $e');
      return [];
    }
  }

  static Future<dynamic> getProductById(String productId) async {
    try {
      final response = await _dio.get(
          Uri.parse('http://192.168.159.138:4000/products/$productId')
              as String);
      return Product.fromJson(json.decode(response.data));
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  static Future<Response> createProduct(
      Map<String, dynamic> productData, File? imageFile) async {
    final formData = FormData.fromMap(productData);

    if (imageFile != null) {
      formData.files.add(MapEntry(
        'urlImage',
        await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      ));
    }

    try {
      final response = await _dio.post(
        'http://192.168.159.138:4000/products/create',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "multipart/form-data",
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error creating product: $e');
      rethrow;
    }
  }

//update product
  static Future<Response> updateProduct(String productId,
      Map<String, dynamic> productData, File? imageFile) async {
    final formData = FormData.fromMap(productData);

    if (imageFile != null) {
      formData.files.add(MapEntry(
        'urlImage',
        await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      ));
    }

    try {
      final response = await _dio.put(
        'http://192.168.159.138:4000/products/$productId',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "multipart/form-data",
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  // Add the deleteProduct method here
  static Future<void> deleteProduct(int productId) async {
    try {
      await _dio.delete('http://192.168.159.138:4000/products/$productId');
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}
