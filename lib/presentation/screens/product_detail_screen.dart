import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../../data/services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();

  Product? _product;

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final product = await _productService.getProduct(widget.productId);

      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load product'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadProduct,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_product == null) {
      return const Center(
        child: Text('Product not found'),
      );
    }

    final product = _product!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              itemCount: product.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  product.images[index],
                  fit: BoxFit.contain,
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 12),

          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(product.rating.toString()),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 8),

          Text(product.description),
        ],
      ),
    );
  }
}