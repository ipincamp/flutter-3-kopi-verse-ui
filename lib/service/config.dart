class Config {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String authUrl = '$baseUrl/auth';
  static const String productUrl = '$baseUrl/products';
  static const String cartUrl = '$baseUrl/cart';

  static const List<String> bgList = [
    "assets/images/bg1.jpeg",
    "assets/images/bg2.webp",
    "assets/images/bg3.jpeg",
    "assets/images/bg4.jpeg",
    "assets/images/bg5.jpeg",
  ];

  static Map<String, String> headers({String? token}) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
