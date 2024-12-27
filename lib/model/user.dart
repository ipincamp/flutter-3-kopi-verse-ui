class User {
  final String uniqueId;
  final String name;
  final String email;
  final String image;
  final String role;
  final String joinSince;
  final int allOrders;

  User({
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.image,
    required this.role,
    required this.joinSince,
    required this.allOrders,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uniqueId: json['unique_id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      role: json['role'],
      joinSince: json['join_since'],
      allOrders: json['all_orders'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unique_id': uniqueId,
      'name': name,
      'email': email,
      'image': image,
      'role': role,
      'join_since': joinSince,
      'all_orders': allOrders,
    };
  }
}
