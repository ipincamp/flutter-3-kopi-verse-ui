class Config {
  static String baseUrl = 'http://127.0.0.1:8000';
  static String authUrl = '$baseUrl/api/auth';
  static String productUrl = '$baseUrl/api/products';
  static String cartUrl = '$baseUrl/api/cart';
  static String orderUrl = '$baseUrl/api/orders';
  static String uploadUrl = '$baseUrl/api/files';
  static String userUrl = '$baseUrl/api/users';

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
