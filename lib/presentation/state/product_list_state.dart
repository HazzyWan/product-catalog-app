import '../../data/models/product.dart';

// Represents every possible situation the product list screen can be in.
// Only one of these can be true at any given moment.
sealed class ProductListState{}

// Shown while the first page of products is being fetched.
class ProductListLoading extends ProductListState {}

// Shown when the fetch finishes but there are no products at all.
class ProductListEmpty extends ProductListState {}

// Shown when the fetch succeeds and there is at least one product.
// Holds the actual list, plus whether more pages might still be loading.
class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final bool isLoadingMore; // true if the next page is being fetched

  ProductListLoaded({
    required this.products,
    this.isLoadingMore = false,
  });
}

// Shown when the fetch fails. Holds a message to display,
// so the retry button knows what went wrong.
class ProductListError extends ProductListState {
  final String message;

  ProductListError(this.message);
}