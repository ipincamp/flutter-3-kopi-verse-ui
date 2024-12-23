class User {
  final String uniqueId;
  final String name;
  final String email;
  final String role;
  final String joinSince;
  final String image;
  final int allOrders;

  User({
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.joinSince,
    required this.role,
    required this.image,
    required this.allOrders,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uniqueId: json['unique_id'],
      name: json['name'],
      email: json['email'],
      joinSince: json['join_since'],
      role: json['role'],
      image: json['image'],
      allOrders: json['all_orders'],
    );

/*
    [
          {
            id: 9dcb45a7-d67d-4c9d-86ef-a58b9c97d70b,
            name: User Cashier,
            email: cashier@cshop.com,
            role: cashier,
            joined_at: 5 hours ago,
            image: picture.jpg
          },
          {
            id: 9dcb45a8-f624-41ed-b0e4-fdf68b26e477,
            name: User Customer,
            email: customer@cshop.com,
            role: customer,
            joined_at: 5 hours ago,
            image: picture.jpg
          }
        ]
*/
  }

  Map<String, dynamic> toJson() {
    return {
      'unique_id': uniqueId,
      'name': name,
      'email': email,
      'join_since': joinSince,
      'role': role,
      'image': image,
      'all_orders': allOrders,
    };
  }
}
