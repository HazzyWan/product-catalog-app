// All fields are final, a Product is fixed once created.
// If data changes, we fetch a new Product rather than changing this one.
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;
  final List<String> images;

  // Named parameters (id: ..., title: ...) label each value explicitly,
  // so reordering fields later can't silently swap wrong values int the wrong properties.
  // `required` forces every field to be provided — Dart won't compile if one is missing.
Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
  });

 // Factory constructor: converts raw JSON (from the API) into a Product.
factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      // Cast through num first since JSON numbers can arrive as int or double.
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      thumbnail: json['thumbnail'],
      // Convert List<dynamic> from JSON into a properly typed List<String>
      images: List<String>.from(json['images']),
    );
  }
}