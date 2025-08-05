import 'package:flutter/material.dart';

class APIs {
  // static String baseUrl = "http://127.0.0.1:8000"; // dev server
  static String baseUrl = "http://10.0.2.2:8000"; // emulator dev server

  // ---------------- Auth ----------------
  static String login = "$baseUrl/auth/login";
  static String register = "$baseUrl/auth/register";
  static String currentUser = "$baseUrl/auth/me";
  static String logout = "$baseUrl/auth/logout";

  // ---------------- Category ----------------
  static String allCategories = "$baseUrl/categories";
  static String createCategory = "$baseUrl/categories/create";
  static String categoryWithProducts(String id) => "$baseUrl/categories/$id";
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

class Pallete {
  static const primary = Colors.deepPurpleAccent;
  static const secondary = Color(0x667C4DFF);
  static const background = Color(0xFFF3E5F5);
  static const surface = Color(0xFFD1C4E9);

  static const error = Color(0xFFFF5252);
  static const success = Color(0xFF66BB6A);
  static const info = Color(0xFF448AFF);
  static const warning = Colors.amber;
}
