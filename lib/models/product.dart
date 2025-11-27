class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  final String description;

  List<Map<String, dynamic>> reviews; // ✅ ADD THIS

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.description,
    this.reviews = const [], // ✅ DEFAULT EMPTY
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: (json['price'] as num).toDouble(),
        category: json['category'],
        imageUrl: json['imageUrl'],
        description: json['description'],
        reviews: json['reviews'] != null
            ? List<Map<String, dynamic>>.from(json['reviews'])
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'description': description,
        'reviews': reviews, // ✅ KEEP IT
      };
}
