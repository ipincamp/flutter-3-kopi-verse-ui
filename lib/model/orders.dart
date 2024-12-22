class Orders {
  final String barcode;
  final String customer;
  final String date;
  final int totalPrice;
  final String status;

  Orders({
    required this.barcode,
    required this.customer,
    required this.date,
    required this.totalPrice,
    required this.status,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      barcode: json['barcode'],
      customer: json['customer'],
      date: json['date'],
      totalPrice: json['total'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'customer': customer,
      'date': date,
      'total': totalPrice,
      'status': status,
    };
  }
}
