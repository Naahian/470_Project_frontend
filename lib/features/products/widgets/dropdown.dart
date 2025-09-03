import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/products/controllers/product_controller.dart';

enum FilterType { category, supplier }

class FilterDropDown extends ConsumerWidget {
  const FilterDropDown({super.key, required this.filterType});

  final FilterType filterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(productControllerProvider.notifier);
    final state = ref.watch(productControllerProvider);

    return Expanded(
      child: DropdownButtonFormField<String>(
        value: _getSelectedValue(state),
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
        ),
        iconEnabledColor: Pallete.primary,
        items: [
          DropdownMenuItem(value: null, child: Text(_getAllLabel())),
          ..._getFilterItems(
            controller,
          ).map((item) => DropdownMenuItem(value: item, child: Text(item))),
        ],
        onChanged: (value) {
          _handleFilterChange(value, controller);
        },
      ),
    );
  }

  String? _getSelectedValue(ProductState state) {
    switch (filterType) {
      case FilterType.category:
        return state.selectedCategory;
      case FilterType.supplier:
        return state.selectedSupplier;
    }
  }

  List<String> _getFilterItems(ProductController controller) {
    switch (filterType) {
      case FilterType.category:
        return controller.categories.map((item) => item.name).toList();
      case FilterType.supplier:
        return controller.suppliers.map((item) => item.name).toList();
    }
  }

  String _getAllLabel() {
    switch (filterType) {
      case FilterType.category:
        return 'All Categories';
      case FilterType.supplier:
        return 'All Suppliers';
    }
  }

  void _handleFilterChange(String? value, ProductController controller) {
    switch (filterType) {
      case FilterType.category:
        controller.updateCategoryFilter(value);
        break;
      case FilterType.supplier:
        controller.updateSupplierFilter(value);
        break;
    }
  }
}
