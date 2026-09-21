import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_list_provider.dart';
import '../state/product_list_state.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart'; // navigates here when a product is tapped

// StatefulWidget: unlike StatelessWidget, this can hold onto internal
// values (like scroll position) that change over time.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Tracks how far the user has scrolled, so pagination can be triggered
  // near the bottom of the list.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // Runs once, when this screen is first created.
    super.initState();
    // Watches for scroll position changes.
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Runs once, when this screen is removed. Cleans up the controller
    // to avoid memory leaks.
    _scrollController.dispose();
    super.dispose();
  }

  // Checks scroll position on every scroll event.
  void _onScroll() {
    // True once the user has scrolled within 200 pixels of the bottom.
    final nearBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;

    if (nearBottom) {
      // "read" = trigger an action once, without rebuilding this widget
      // every time the provider changes (unlike "watch" below).
      context.read<ProductListProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // "watch" = rebuild this widget automatically whenever the
    // provider's state changes.
    final state = context.watch<ProductListProvider>().state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: TextField(
          style: const TextStyle(color: Colors.white, fontSize: 18),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (query) =>
              context.read<ProductListProvider>().onSearchChanged(query),
        ),
      ),
      // Wrapping the body in RefreshIndicator adds pull-to-refresh
      // (swipe down to reload) with almost no extra code.
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductListProvider>().loadInitial(),
        child: _buildBody(state),
      ),
    );
  }

  // Decides which widget to show based on the current state.
  // Each possible state is handled explicitly and separately.
  Widget _buildBody(ProductListState state) {
    // Loading state: show a spinner in the center of the screen.
    if (state is ProductListLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state: show the error message and a retry button.
    if (state is ProductListError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Something went wrong:\n${state.message}',
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  context.read<ProductListProvider>().loadInitial(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty state: no products were returned, but no error occurred either.
    if (state is ProductListEmpty) {
      return const Center(child: Text('No products found.'));
    }

    // At this point, every other possibility has been handled above,
    // so this must be the loaded state. "as" tells Dart to treat it
    // as that specific type from here on.
    final loaded = state as ProductListLoaded;

    return ListView.builder(
      controller: _scrollController,
      // Adds one extra slot at the end for a loading spinner,
      // but only while the next page is being fetched.
      itemCount: loaded.products.length + (loaded.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // If this is the extra slot beyond the real product list,
        // show a small loading spinner instead of a product.
        if (index >= loaded.products.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final product = loaded.products[index];
        // Wraps the card so tapping it navigates to the detail screen,
        // passing along which product's id to fetch details for.
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: product.id),
            ),
          ),
          child: ProductCard(product: product),
        );
      },
    );
  }
}