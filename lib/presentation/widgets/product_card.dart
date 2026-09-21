import 'package:flutter/material.dart';
import '../../data/models/product.dart';

// Displays one product's thumbnail, title, and price in a single row.
// Used inside the scrolling list on the product list screen.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // The small image shown on the left side of the row.
      leading: Image.network(
        product.thumbnail,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        // Runs while the image is still being downloaded.
        // Shows a small spinner instead of a blank space.
        loadingBuilder: (context, child, progress) {
          // progress becomes null once the image has fully loaded.
          if (progress == null) return child;
          return const SizedBox(
            width: 56,
            height: 56,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        // Runs if the image fails to load entirely (broken link, no
        // internet, etc.). Shows a placeholder icon instead of crashing.
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
      ),
      title: Text(product.title),
      subtitle: Text('\$${product.price}'),
    );
  }
}