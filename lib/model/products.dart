class Products {
  final String id;
  final String name;
  final int price;
  final String category;
  final String image;

  Products({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'image': image,
    };
  }
}
