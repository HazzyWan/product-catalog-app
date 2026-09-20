import '../models/product.dart';
import '../services/product_api.dart';

// Sits between the API service and the UI.
// The UI only talks to this class — it never calls ProductApi directly.
class ProductRepository {
  final ProductApi _api;

  // Keeps track of pagination as pages are loaded.
  int _currentSkip = 0;
  static const int _pageSize = 20;

  ProductRepository({ProductApi? api}) : _api = api ?? ProductApi();

  // Resets pagination and loads the first page.
  // Used when the screen first opens, or on pull-to-refresh.
  Future<List<Product>> loadFirstPage() async {
    _currentSkip = 0;
    final products = await _api.fetchProducts(limit: _pageSize, skip: _currentSkip);
    _currentSkip += products.length;
    return products;
  }

  // Loads the next page, continuing from wherever pagination left off.
  // Used when the user scrolls near the bottom of the list.
  Future<List<Product>> loadNextPage() async {
    final products = await _api.fetchProducts(limit: _pageSize, skip: _currentSkip);
    _currentSkip += products.length;
    return products;
  }

  // Gets full details for one product, for the detail screen.
  Future<Product> getProductDetail(int id) {
    return _api.fetchProductDetail(id);
  }

  // Searches for products matching a typed-in query.
  Future<List<Product>> search(String query) {
    return _api.searchProducts(query);
  }
}