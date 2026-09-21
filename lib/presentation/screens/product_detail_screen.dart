import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_detail_provider.dart';
import '../state/product_detail_state.dart';

// Shows full details for one product: images, title, price, rating,
// and description. Which product depends on the id passed in.
class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Creates a fresh provider scoped to just this screen, and
    // immediately starts fetching this specific product's details.
    return ChangeNotifierProvider(
      create: (_) => ProductDetailProvider()..loadDetail(productId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        // Consumer rebuilds only this part of the tree when the
        // provider's state changes, rather than the whole screen.
        body: Consumer<ProductDetailProvider>(
          builder: (context, provider, _) => _buildBody(context, provider.state),
        ),
      ),
    );
  }

  // Picks which widget to show based on the current state.
  Widget _buildBody(BuildContext context, ProductDetailState state) {
    // Loading state: show a spinner while the fetch is in progress.
    if (state is ProductDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state: show the error message with a retry button.
    if (state is ProductDetailError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Something went wrong:\n${state.message}',
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context
                  .read<ProductDetailProvider>()
                  .loadDetail(productId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Only the loaded state remains at this point.
    final loaded = state as ProductDetailLoaded;
    final product = loaded.product;

    // Makes the content scrollable in case it's taller than the screen.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A horizontally scrollable strip of all the product's images.
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.images.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.network(
                  product.images[index],
                  width: 200,
                  fit: BoxFit.cover,
                  // Shown if a specific image fails to load.
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Product title, using the app's predefined heading text style.
          Text(product.title,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),

          // Price and star rating shown side by side.
          Row(
            children: [
              Text('\$${product.price}',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: 16),
              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(product.rating.toString()),
            ],
          ),
          const SizedBox(height: 16),

          // Full product description text.
          Text(product.description),
        ],
      ),
    );
  }
}