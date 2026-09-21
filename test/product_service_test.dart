import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_app/data/models/product_response.dart';

void main() {
  test('ProductResponse parses product JSON correctly', () {
    final json = {
      'products': [
        {
          'id': 1,
          'title': 'Test Product',
          'description': 'A test product',
          'price': 99.99,
          'rating': 4.5,
          'thumbnail': 'https://example.com/image.jpg',
          'images': [
            'https://example.com/image1.jpg',
            'https://example.com/image2.jpg',
          ],
        },
      ],
      'total': 1,
      'skip': 0,
      'limit': 20,
    };

    final result = ProductResponse.fromJson(json);

    expect(result.products.length, 1);
    expect(result.products.first.id, 1);
    expect(result.products.first.title, 'Test Product');
    expect(result.products.first.price, 99.99);
    expect(result.total, 1);
    expect(result.skip, 0);
    expect(result.limit, 20);
  });
}