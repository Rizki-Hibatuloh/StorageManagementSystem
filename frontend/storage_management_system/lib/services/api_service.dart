import 'dart:io';

import 'package:dio/dio.dart';
import 'package:storage_management_system/models/product.dart';
import 'package:storage_management_system/services/auth_services.dart';

class ApiService {
  static final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://192.168.88.138:4000'));

  // Fungsi untuk mendapatkan username dari AuthService
  static Future<String?> _getUsername() async {
    AuthService authService = AuthService();
    return await authService.getUsername();
  }

  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get('http://192.168.88.138:4000/categories');
      return response.data;
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio
          .get('http://192.168.88.138:4000/products?category=$categoryId');
      return response.data;
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getAllProducts() async {
    try {
      final response = await _dio.get('http://192.168.88.138:4000/products');
      return response.data;
    } catch (e) {
      print('Error getting all products: $e');
      return [];
    }
  }

  static Future<Product?> getProductById(String productId) async {
    try {
      print('Fetching product with ID: $productId');
      final response =
          await _dio.get('http://192.168.88.138:4000/products/$productId');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return Product.fromJson(response.data);
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  static Future<Response> createProduct(
      Map<String, dynamic> productData, File? imageFile) async {
    final username = await _getUsername();
    if (username != null) {
      productData['createdBy'] = username;
    }

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
        'http://192.168.88.138:4000/products/create',
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

  static Future<Response> updateProduct(String productId,
      Map<String, dynamic> productData, File? imageFile) async {
    final username = await _getUsername();
    if (username != null) {
      productData['updatedBy'] = username;
    }

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
        'http://192.168.88.138:4000/products/$productId',
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

  static Future<void> deleteProduct(int productId) async {
    try {
      final response =
          await _dio.delete('http://192.168.88.138:4000/products/$productId');
      if (response.statusCode == 200) {
        print('Product deleted successfully');
      } else {
        print('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        // Provide more detailed information about the error
        print('Error deleting product: ${e.message}');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Error deleting product: $e');
      }
    }
  }
}
