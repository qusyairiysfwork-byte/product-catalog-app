import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../../data/services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  final ScrollController _scrollController = ScrollController();

  final List<Product> _products = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;

  int _skip = 0;
  final int _limit = 20;
  int _total = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _loadProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await _productService.getProducts(
        limit: _limit,
        skip: 0,
      );

      setState(() {
        _products.clear();
        _products.addAll(result.products);

        _skip = result.skip + result.products.length;
        _total = result.total;

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || _products.length >= _total) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = await _productService.getProducts(
        limit: _limit,
        skip: _skip,
      );

      setState(() {
        _products.addAll(result.products);

        _skip = result.skip + result.products.length;

        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
            const Text('Failed to load products'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _products.length + 1,
      itemBuilder: (context, index) {
        if (index == _products.length) {
          if (_isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (_products.length >= _total) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('No more products'),
              ),
            );
          }

          return const SizedBox.shrink();
        }

        final product = _products[index];

        return ListTile(
          leading: Image.network(
            product.thumbnail,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          title: Text(product.title),
          subtitle: Text(
            '\$${product.price.toStringAsFixed(2)}',
          ),
        );
      },
    );
  }
}