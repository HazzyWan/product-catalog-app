import 'dart:convert'; // lets this file read JSON text and turn it into normal Dart data
import 'package:http/http.dart' as http; // the tool used to make internet requests
import '../models/product.dart'; // the Product blueprint, used to build Product objects from JSON

// This file's only job: talk to the DummyJSON website and get product data back.
// It does not touch anything about how the app looks.
class ProductApi {
  // The main web address all requests are built from.
  // Kept private (underscore) so only this file uses it directly.
  static const String _baseUrl = 'https://dummyjson.com/products';

  // Gets one "page" of products from the API.
  // limit = how many products to get. skip = how many to skip (for pagination).
  // If nothing is passed in, it defaults to the first 20 products.
  Future<List<Product>> fetchProducts({int limit = 20, int skip = 0}) async {
    // Builds the full web address, e.g. .../products?limit=20&skip=0
    final url = Uri.parse('$_baseUrl?limit=$limit&skip=$skip');

    // Actually sends the request to the internet and waits for a reply.
    // "await" just means: pause here until the answer comes back.
    final response = await http.get(url);

    // 200 means the request worked. Anything else means something went wrong.
    if (response.statusCode != 200) {
      throw Exception('Failed to load products (status ${response.statusCode})');
    }

    // The reply comes back as plain text. This line turns that text
    // into something Dart can actually work with (like a dictionary).
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    // The actual list of products is stored inside a "products" key.
    // At this point each product is still raw, unprocessed data.
    final List<dynamic> productsJson = data['products'];

    // Turns each raw product into a proper Product object,
    // then collects them all into one list to return.
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }

  // Gets the full details for one product, using its id number.
  Future<Product> fetchProductDetail(int id) async {
    // The id goes directly into the address, e.g. .../products/5
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load product $id (status ${response.statusCode})');
    }

    // This reply is just one product, not a list, so it's converted directly.
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(json);
  }

  // Searches for products that match a typed-in word or phrase.
  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse('$_baseUrl/search?q=$query');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to search products (status ${response.statusCode})');
    }

    // Same shape as the product list reply — results are under "products".
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> productsJson = data['products'];

    return productsJson.map((json) => Product.fromJson(json)).toList();
  }
}