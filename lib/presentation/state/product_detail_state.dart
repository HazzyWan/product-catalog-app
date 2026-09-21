import '../../data/models/product.dart';

// Represents every possible situation the detail screen can be in.
sealed class ProductDetailState {}

// Shown while the product's full details are being fetched.
class ProductDetailLoading extends ProductDetailState {}

// Shown when the fetch succeeds. Holds the actual product data.
class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  ProductDetailLoaded(this.product);
}

// Shown when the fetch fails. Holds a message for the retry UI.
class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError(this.message);
}