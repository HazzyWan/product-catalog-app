import 'package:flutter/foundation.dart';
import '../../data/repositories/product_repository.dart';
import '../state/product_detail_state.dart';

// Connects the detail screen to ProductRepository.
// Holds the current state for one specific product's details.
class ProductDetailProvider extends ChangeNotifier {
  final ProductRepository _repository;

  // Same pattern as ProductListProvider: use the repository passed in,
  // or create a new one if none was given (useful for testing later).
  ProductDetailProvider({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  // Starts as loading, since no product has been fetched yet.
  ProductDetailState _state = ProductDetailLoading();
  ProductDetailState get state => _state;

  // Fetches full details for one product, identified by its id.
  Future<void> loadDetail(int id) async {
    _state = ProductDetailLoading();
    // Announces the state change so the screen shows a spinner.
    notifyListeners();

    try {
      final product = await _repository.getProductDetail(id);
      _state = ProductDetailLoaded(product);
    } catch (e) {
      // If the fetch fails, switch to the error state instead of crashing.
      _state = ProductDetailError(e.toString());
    }

    // Announces the final result, whether success or failure.
    notifyListeners();
  }
}