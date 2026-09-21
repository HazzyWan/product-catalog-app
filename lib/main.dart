import 'package:flutter/material.dart'; // core Flutter UI widgets
import 'package:provider/provider.dart'; // state management package
import 'presentation/providers/product_list_provider.dart';
import 'presentation/screens/product_list_screen.dart';

// The very first function that runs when the app starts.
void main() {
  runApp(const MyApp());
}

// The root widget of the entire app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Makes one ProductListProvider available to every widget below it,
    // without manually passing it down through constructors.
    return ChangeNotifierProvider(
      // Creates the provider, then immediately starts loading the first page.
      // ".." means "call this method on the object just created, then keep
      // using that same object" (avoids writing two separate lines).
      create: (_) => ProductListProvider()..loadInitial(),
      child: MaterialApp(
        title: 'Product Catalog',
        theme: ThemeData(primarySwatch: Colors.indigo),
        // The first screen shown when the app opens.
        home: const ProductListScreen(),
      ),
    );
  }
}