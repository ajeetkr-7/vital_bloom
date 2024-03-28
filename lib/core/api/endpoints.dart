

class Endpoints {
  static const baseUrl = "http://127.0.0.1:8081/";

  static const signUp = "auth/signup";
  static const verifyOtp = "auth/confirmOtp";
  static const getOtp = "auth/getOtp";
  static const logout = "auth/logout";
  

  static const searchProducts = "products/search";
  static const deals = "api/deals";

  static String getProductById(String alias, String productId) {
    return "products/$alias/$productId";
  }
}