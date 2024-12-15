class ProductDetail {
  final String id;
  final String name;
  final String detail;
  final int price;
  // final double rating;
  final String image;

  ProductDetail({
    required this.id,
    required this.name,
    required this.detail,
    required this.price,
    // required this.rating,
    required this.image,
  });

  factory ProductDetail.fromJson(json) {
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      price: json['price'],
      // rating: json['rating'],
      image: json['image'],
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'price': price,
      // 'rating': rating,
      'image': image,
    };
  }
}
