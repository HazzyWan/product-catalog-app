import 'package:flutter/foundation.dart';
import '../../data/repositories/product_repository.dart';
import '../state/product_list_state.dart';

// Connects the UI to ProductRepository.
// Holds the current screen state and notifies the UI whenever it changes.
class ProductListProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductListProvider({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  // Starts as loading, since data hasn't been fetched yet.
  ProductListState _state = ProductListLoading();
  ProductListState get state => _state;

  // Tracks whether there might still be more pages to load.
  bool _hasMore = true;

  // Fetches the first page. Called when the screen first opens,
  // or when the user pulls to refresh.
  Future<void> loadInitial() async {
    _state = ProductListLoading();
    notifyListeners();

    try {
      final products = await _repository.loadFirstPage();
      _hasMore = products.isNotEmpty;

      _state = products.isEmpty
          ? ProductListEmpty()
          : ProductListLoaded(products: products);
    } catch (e) {
      _state = ProductListError(e.toString());
    }

    notifyListeners();
  }

  // Fetches the next page. Called when the user scrolls near the bottom.
  Future<void> loadMore() async {
    // Only proceed if currently in a loaded state and more pages might exist.
    final current = _state;
    if (current is! ProductListLoaded || !_hasMore || current.isLoadingMore) {
      return;
    }

    // Show a small "loading more" flag without losing the current list.
    _state = ProductListLoaded(
      products: current.products,
      isLoadingMore: true,
    );
    notifyListeners();

    try {
      final newProducts = await _repository.loadNextPage();
      _hasMore = newProducts.isNotEmpty;

      _state = ProductListLoaded(
        products: [...current.products, ...newProducts],
        isLoadingMore: false,
      );
    } catch (e) {
      // If loading more fails, keep showing the existing list rather
      // than replacing the whole screen with an error.
      _state = ProductListLoaded(
        products: current.products,
        isLoadingMore: false,
      );
    }

    notifyListeners();
  }
}