import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/category/models/category_model.dart';
// import 'package:inventory_management_app/features/suppliers/controllers/supplier_controller.dart'; // Assuming you have this
import 'package:inventory_management_app/features/products/controllers/product_controller.dart';
import 'package:inventory_management_app/features/products/models/product_model.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_model.dart';

import '../controllers/addproduct_controller.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedCategoryId;
  int? _selectedSupplierId;
  String? _selectedCategoryName;
  String? _selectedSupplierName;

  @override
  Widget build(BuildContext context) {
    // Call fetchAll only once when the dialog is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(addProductControllerProvider).categories.isEmpty &&
          ref.read(addProductControllerProvider).suppliers.isEmpty &&
          !ref.read(addProductControllerProvider).isLoading) {
        ref.read(addProductControllerProvider.notifier).fetchAll();
      }
    });

    final addProductState = ref.watch(addProductControllerProvider);

    return AlertDialog(
      title: const Text('Add Product'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show error if any
            if (addProductState.error != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        addProductState.error!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Category Dropdown
            addProductState.isLoading
                ? const _LoadingDropdown(label: 'Category')
                : _buildCategoryDropdown(addProductState.categories),
            const SizedBox(height: 16),

            // Supplier Dropdown
            addProductState.isLoading
                ? const _LoadingDropdown(label: 'Supplier') // Fixed label
                : _buildSupplierDropdown(addProductState.suppliers),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canSubmit() ? _handleSubmit : null,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(List<CategoryModel> categories) {
    return DropdownButtonFormField<int>(
      value: _selectedCategoryId,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      hint: const Text('Select a category'),
      items: categories.map((category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          final selectedCategory = categories.firstWhere(
            (cat) => cat.id == value,
          );
          setState(() {
            _selectedCategoryId = selectedCategory.id;
            _selectedCategoryName = selectedCategory.name;
          });
        }
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildSupplierDropdown(List<SupplierModel> suppliers) {
    return DropdownButtonFormField<int>(
      value: _selectedSupplierId,
      decoration: const InputDecoration(
        labelText: 'Supplier',
        border: OutlineInputBorder(),
      ),
      hint: const Text('Select a supplier'),
      items: suppliers.map((supplier) {
        return DropdownMenuItem<int>(
          value: supplier.id,
          child: Text(supplier.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          final selectedSupplier = suppliers.firstWhere(
            (sup) => sup.id == value,
          );
          setState(() {
            _selectedSupplierId = selectedSupplier.id;
            _selectedSupplierName = selectedSupplier.name;
          });
        }
      },
      validator: (value) => value == null ? 'Please select a supplier' : null,
    );
  }

  bool _canSubmit() {
    return _selectedCategoryId != null &&
        _selectedSupplierId != null &&
        _selectedCategoryName != null &&
        _selectedSupplierName != null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final newProduct = ProductCreateModel(
        categoryName: _selectedCategoryName!,
        supplierName: _selectedSupplierName!,
        categoryId: _selectedCategoryId!,
        supplierId: _selectedSupplierId!,
      );

      Future.wait([
        ref.read(addProductControllerProvider.notifier).addProduct(newProduct),
        ref.read(productControllerProvider.notifier).fetchAllProducts(),
      ]);

      Navigator.of(context).pop();
    }
  }
}

// Helper widgets for loading and error states
class _LoadingDropdown extends StatelessWidget {
  final String label;

  const _LoadingDropdown({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text('Loading $label...', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ErrorDropdown extends StatelessWidget {
  final String label;
  final String error;

  const _ErrorDropdown({required this.label, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.error, color: Colors.red, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error loading $label',
              style: const TextStyle(color: Colors.red),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
