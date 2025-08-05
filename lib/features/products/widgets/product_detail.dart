import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';

class ProductDetail extends StatelessWidget {
  final String productId;
  final String category;
  final String supplier;
  final String lastUpdated;
  final bool inStock;

  const ProductDetail({
    super.key,
    required this.productId,
    required this.category,
    required this.supplier,
    required this.lastUpdated,
    required this.inStock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Last Updated: ${lastUpdated}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 3),
            ),
          ),
          _buildStatus(inStock),
          _buildTile(Icons.inventory, "Product Id", "#${productId}"),
          _buildTile(Icons.category, "Category", category),
          _buildTile(Icons.local_shipping, "Supplier", supplier),
        ],
      ),
    );
  }

  Container _buildStatus(bool status) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      decoration: BoxDecoration(
        color: status
            ? Pallete.success.withAlpha(80)
            : Pallete.info.withAlpha(80),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(status ? "IN STOCK" : "SOLD", style: TextStyle(fontSize: 20)),
    );
  }

  ListTile _buildTile(IconData icon, String label, String value) {
    return ListTile(
      minVerticalPadding: 10,
      leading: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Pallete.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(label),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
