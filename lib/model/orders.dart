class Orders {
  final String barcode;
  final int totalPrice;
  final String status;

  Orders({
    required this.barcode,
    required this.totalPrice,
    required this.status,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      barcode: json['barcode'],
      totalPrice: json['total'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'total': totalPrice,
      'status': status,
    };
  }
}
