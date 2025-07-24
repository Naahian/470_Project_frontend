class APIs {
  // static String baseUrl = "http://127.0.0.1:8000";
  static String baseUrl = "http://10.0.2.2:8000";

  // ---------------- Auth ----------------
  static String login = "$baseUrl/auth/login";
  static String register = "$baseUrl/auth/register";
  static String currentUser = "$baseUrl/auth/me";
  static String logout = "$baseUrl/auth/logout";

  // ---------------- Category ----------------
  static String allCategories = "$baseUrl/categories";
  static String createCategory = "$baseUrl/categories";
  static String categoryWithProducts = "$baseUrl/categories/products";
  static String updateCategory(String id) => "$baseUrl/categories/$id";
  static String deleteCategory(String id) => "$baseUrl/categories/$id";

  // ---------------- Product ----------------
  static String allProducts = "$baseUrl/products";
  static String singleProduct(String id) => "$baseUrl/products/$id";
  static String createProduct = "$baseUrl/products";
  static String updateProduct(String id) => "$baseUrl/products/$id";
  static String deleteProduct(String id) => "$baseUrl/products/$id";

  // ---------------- Supplier ----------------
  static String createSupplier = "$baseUrl/suppliers";
  static String allSuppliers = "$baseUrl/suppliers";
  static String singleSupplier(String id) => "$baseUrl/suppliers/$id";
  static String updateSupplier(String id) => "$baseUrl/suppliers/$id";
  static String deleteSupplier(String id) => "$baseUrl/suppliers/$id";

  // ---------------- User ----------------
  static String deleteUser(String id) => "$baseUrl/users/$id";
  static String updateUser(String id) => "$baseUrl/users/$id";
  static String allUsers = "$baseUrl/users";
  static String singleUser(String id) => "$baseUrl/users/$id";
}
