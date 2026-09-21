import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/product_response.dart';

class ProductService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<ProductResponse> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/products?limit=$limit&skip=$skip',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }

    final json = jsonDecode(response.body);

    return ProductResponse.fromJson(json);
  }

  Future<Product> getProduct(int id) async {
    final uri = Uri.parse('$_baseUrl/products/$id');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load product');
    }

    final json = jsonDecode(response.body);

    return Product.fromJson(json);
  }

  Future<ProductResponse> searchProducts(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/products/search?q=${Uri.encodeQueryComponent(query)}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to search products');
    }

    final json = jsonDecode(response.body);

    return ProductResponse.fromJson(json);
  }
}