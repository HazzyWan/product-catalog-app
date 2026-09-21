import 'dart:async'; // Needed for Timer (debounce)
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

  // Holds a pending debounce timer, so rapid typing doesn't
  // fire a network request on every single keystroke.
  Timer? _debounce;

  // Tracks whether current results came from a search or the
  // normal paginated list, so loadMore() knows whether to paginate.
  bool _isSearching = false;

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
    final current = _state;
    // Added `|| _isSearching` so pagination is skipped
    // while search results are being shown.
    if (current is! ProductListLoaded ||
        !_hasMore ||
        current.isLoadingMore ||
        _isSearching) {
      return;
    }

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
      _state = ProductListLoaded(
        products: current.products,
        isLoadingMore: false,
      );
    }

    notifyListeners();
  }

  // Called every time the search box's text changes.
  void onSearchChanged(String query) {
    // Cancels any previously scheduled search that hasn't fired yet.
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      // If the search box is cleared, go back to the normal list.
      _isSearching = false;
      loadInitial();
      return;
    }

    // Waits 500ms after the user stops typing before actually searching.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query.trim());
    });
  }

  // Performs the actual search request.
  Future<void> _search(String query) async {
    _isSearching = true;
    _state = ProductListLoading();
    notifyListeners();

    try {
      final results = await _repository.search(query);
      _state = results.isEmpty
          ? ProductListEmpty()
          : ProductListLoaded(products: results);
    } catch (e) {
      _state = ProductListError(e.toString());
    }

    notifyListeners();
  }

  // Cancels any pending timer when this provider is destroyed,
  // to avoid it firing after the screen is gone.
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}