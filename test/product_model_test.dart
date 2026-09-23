import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_app/data/models/product.dart';

void main() {
  group('Product.fromJson', () {
    test('correctly parses a full, well-formed JSON map', () {
      // A sample JSON map shaped like what DummyJSON actually returns.
      final json = {
        'id': 1,
        'title': 'iPhone 9',
        'description': 'An apple mobile which is nothing like apple',
        'price': 549,
        'rating': 4.69,
        'thumbnail': 'https://dummyjson.com/thumbnail.jpg',
        'images': [
          'https://dummyjson.com/image1.jpg',
          'https://dummyjson.com/image2.jpg',
        ],
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'iPhone 9');
      expect(product.description, 'An apple mobile which is nothing like apple');
      expect(product.price, 549.0);
      expect(product.rating, 4.69);
      expect(product.thumbnail, 'https://dummyjson.com/thumbnail.jpg');
      expect(product.images.length, 2);
    });

    test('correctly converts an integer price into a double', () {
      // DummyJSON can return price as either an int or a double
      // depending on the value. This confirms both are handled safely.
      final json = {
        'id': 2,
        'title': 'Test Product',
        'description': 'Test description',
        'price': 100, // deliberately an int, not 100.0
        'rating': 4.0,
        'thumbnail': 'https://example.com/thumb.jpg',
        'images': <String>[],
      };

      final product = Product.fromJson(json);

      expect(product.price, isA<double>());
      expect(product.price, 100.0);
    });

    test('correctly parses an empty images list', () {
      final json = {
        'id': 3,
        'title': 'No Images Product',
        'description': 'Has no images',
        'price': 10.5,
        'rating': 3.0,
        'thumbnail': 'https://example.com/thumb.jpg',
        'images': <String>[],
      };

      final product = Product.fromJson(json);

      expect(product.images, isEmpty);
    });
  });
}