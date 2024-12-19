class Product {
  final String id;
  final String name;
  final String detail;
  final int price;
  final String image;
  final bool available;

  Product({
    required this.id,
    required this.name,
    required this.detail,
    required this.price,
    required this.image,
    required this.available,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      price: json['price'],
      image: json['image'],
      available: json['available'].toLowerCase() == 'yes',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'price': price,
      'image': image,
      'available': available ? 'Yes' : 'No',
    };
  }
}
