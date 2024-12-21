class Cart {
  final String itemId;
  final int itemQuantity;
  final String productId;
  final String productName;
  final String productCategory;
  final String productImage;
  final int productPrice;

  Cart({
    required this.itemId,
    required this.itemQuantity,
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productImage,
    required this.productPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      itemId: json['item_id'],
      itemQuantity: json['item_quantity'],
      productId: json['product_id'],
      productName: json['product_name'],
      productCategory: json['product_category'],
      productImage: json['product_image'],
      productPrice: json['product_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'new_quantity': itemQuantity,
      'product_id': productId,
      'product_name': productName,
      'product_category': productCategory,
      'product_image': productImage,
      'product_price': productPrice,
    };
  }
}
