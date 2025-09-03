import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/products/controllers/product_controller.dart';
import 'package:inventory_management_app/features/products/widgets/product_detail.dart';
import '../models/product_model.dart';

class ProductTile extends ConsumerStatefulWidget {
  const ProductTile({super.key, required this.product});

  final ProductModel product;

  @override
  ConsumerState<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends ConsumerState<ProductTile> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: _isSelected
            ? Border.all(color: Pallete.primary, width: 2)
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => showModalBottomSheet(
          context: context,
          showDragHandle: true,
          elevation: 10,
          backgroundColor: Colors.white,
          builder: (context) => ProductDetail(
            productId: widget.product.id.toString(),
            category: widget.product.categoryName,
            supplier: widget.product.supplierName,
            lastUpdated: widget.product.updatedAt ?? "not found",
            inStock: widget.product.inStock,
          ),
        ),
        leading: _categoryImage(),
        title: Text(
          "#${widget.product.id}",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: _isSelected ? Pallete.primary : null,
          ),
        ),
        subtitle: _info(),
        trailing: _selectButton(),
      ),
    );
  }

  Container _categoryImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue,
        // image: DecorationImage(image: Placeholder()),
      ),
    );
  }

  Column _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category: ${widget.product.categoryName}",
          style: TextStyle(color: _isSelected ? Pallete.primary : null),
        ),
        const SizedBox(height: 5),
        widget.product.inStock
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Pallete.success,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "IN STOCK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Pallete.info,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "SOLD",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _selectButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        onPressed: _toggleSelection,
        iconSize: 34,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isSelected
              ? Icon(
                  Icons.check_circle,
                  key: const ValueKey('selected'),
                  color: Pallete.primary,
                )
              : Icon(
                  Icons.check_circle_outline,
                  key: const ValueKey('unselected'),
                  color: Pallete.primary,
                ),
        ),
        style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero)),
      ),
    );
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });
    _isSelected
        ? ref
              .read(productControllerProvider.notifier)
              .selectProduct(widget.product)
        : ref
              .read(productControllerProvider.notifier)
              .unselectProduct(widget.product);
  }
}
