class OrderItem {
  final String productId;
  final String productName;
  final int productPrice;
  final int quantity;
  final int subTotal;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.subTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      productName: json['product_name'],
      productPrice: json['product_price'],
      quantity: json['quantity'],
      subTotal: json['sub_total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_price': productPrice,
      'quantity': quantity,
      'sub_total': subTotal,
    };
  }
}

class Order {
  final String barcode;
  final String customer;
  final String date;
  final int total;
  final String status;
  final String? notes;
  final List<OrderItem> items;

  Order({
    required this.barcode,
    required this.customer,
    required this.date,
    required this.total,
    required this.status,
    this.notes,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<OrderItem> itemList = itemsFromJson.map((item) => OrderItem.fromJson(item)).toList();

    return Order(
      barcode: json['barcode'],
      customer: json['customer'],
      date: json['date'],
      total: json['total'],
      status: json['status'],
      notes: json['notes'],
      items: itemList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'customer': customer,
      'date': date,
      'total': total,
      'status': status,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
