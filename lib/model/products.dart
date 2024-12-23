class Products {
  final String id;
  final String name;
  final String detail;
  final int price;
  final String category;
  final String image;

  Products({
    required this.id,
    required this.name,
    required this.detail,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      price: json['price'],
      category: json['category'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'price': price,
      'category': category,
      'image': image,
    };
  }
}
