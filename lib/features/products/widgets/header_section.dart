import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/products/controllers/product_controller.dart';
import 'package:inventory_management_app/features/products/widgets/dropdown.dart';

class ProductHeaderSection extends StatelessWidget {
  final ProductController controller;

  const ProductHeaderSection({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Pallete.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildSearchBar(context, controller)),
                SizedBox(width: 10),
                _buildQrscanButton(),
              ],
            ),
            const SizedBox(height: 12),
            // Filters
            Row(
              children: [
                FilterDropDown(filterType: FilterType.category),
                const SizedBox(width: 12),
                FilterDropDown(filterType: FilterType.supplier),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconButton _buildQrscanButton() {
    return IconButton.outlined(
      onPressed: () {
        // Implement QR scanning functionality
      },
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: Colors.white.withAlpha(120)),
      ),
      icon: const Icon(Icons.qr_code_2, size: 32, color: Colors.white),
    );
  }

  Container _buildSearchBar(
    BuildContext context,
    ProductController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        onChanged: (value) {
          controller.updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
