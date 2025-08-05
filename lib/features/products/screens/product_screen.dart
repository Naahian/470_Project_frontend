import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';
import 'package:inventory_management_app/features/products/controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(productControllerProvider.notifier);
    final productsAsyncValue = ref.watch(productControllerProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
      floatingActionButton: _floatingAddButtons(context),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Products'),
        backgroundColor: Pallete.primary,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: -80,
            child: Icon(
              Icons.inventory_2_outlined,
              size: 330,
              color: Pallete.secondary,
            ),
          ),
          Column(
            children: [
              // Search Bar
              ColoredBox(
                color: Pallete.primary,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      _buildSearchBar(controller),
                      const SizedBox(height: 12),
                      // Filters
                      Row(
                        children: [
                          CategoryDropDown(controller: controller),
                          const SizedBox(width: 12),
                          _buildSupplierDropDown(controller),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product List
              Expanded(
                child: productsAsyncValue.when(
                  data: (products) {
                    final filteredProducts = controller.filteredProducts;
                    if (filteredProducts.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: _buildProductList(filteredProducts),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _floatingAddButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: Pallete.primary,
          heroTag: "add_product", // Add unique heroTag
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddProductDialog(),
            );
          },
          child: Icon(Icons.add_rounded, color: Colors.white, size: 36),
        ),
        SizedBox(height: 10),
        FloatingActionButton(
          backgroundColor: Pallete.primary,
          heroTag: "scan_qr", // Add unique heroTag
          onPressed: () {
            // TODO: Implement QR code scanning functionality
            showDialog(
              context: context,
              builder: (context) =>
                  AddProductDialog(), // This should probably be a QR scanner dialog
            );
          },
          child: Icon(Icons.qr_code_2, color: Colors.white, size: 36),
        ),
      ],
    );
  }

  ListView _buildProductList(List<ProductModel> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ProductTile(product: product),
        );
      },
    );
  }

  Expanded _buildSupplierDropDown(ProductController controller) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: controller.selectedSupplier,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
        ),
        iconEnabledColor: Pallete.primary,
        items: [
          const DropdownMenuItem(value: null, child: Text('All Suppliers')),
          ...controller.suppliers.map(
            (supplier) =>
                DropdownMenuItem(value: supplier, child: Text(supplier)),
          ),
        ],
        onChanged: (value) {
          controller.updateSupplierFilter(value);
        },
      ),
    );
  }

  TextField _buildSearchBar(ProductController controller) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey.shade50,
        labelText: 'Search products',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
        controller.updateSearchQuery(value);
      },
    );
  }
}

class CategoryDropDown extends StatelessWidget {
  const CategoryDropDown({super.key, required this.controller});

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: controller.selectedCategory,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
        ),
        iconEnabledColor: Pallete.primary,
        items: [
          const DropdownMenuItem(value: null, child: Text('All Categories')),
          ...controller.categories.map(
            (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
          ),
        ],
        onChanged: (value) {
          controller.updateCategoryFilter(value);
        },
      ),
    );
  }
}
