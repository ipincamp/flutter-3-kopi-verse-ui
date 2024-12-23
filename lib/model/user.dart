class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String joinedAt;
  final String image;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedAt,
    required this.role,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      joinedAt: json['joined_at'],
      role: json['role'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'joined_at': joinedAt,
      'role': role,
      'image': image,
    };
  }
}
