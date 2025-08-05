import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/products/widgets/product_detail.dart';
import '../models/product_model.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({
    super.key,
    required this.product,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  final ProductModel product;
  final bool isSelected;
  final Function(bool)? onSelectionChanged;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(ProductTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _isSelected = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _isSelected ? Pallete.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: _isSelected
            ? Border.all(color: Pallete.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
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
        color: _isSelected ? Pallete.primary : Colors.blue,
        // image: DecorationImage(image: Placeholder()),
      ),
      child: _isSelected
          ? Icon(Icons.check, color: Colors.white, size: 24)
          : null,
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
        SizedBox(height: 5),
        widget.product.inStock
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Pallete.success,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "IN STOCK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Pallete.info,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
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
      duration: Duration(milliseconds: 200),
      child: IconButton(
        onPressed: _toggleSelection,
        icon: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _isSelected
              ? Icon(
                  Icons.check_circle,
                  key: ValueKey('selected'),
                  color: Colors.white,
                )
              : Icon(
                  Icons.check_circle_outline,
                  key: ValueKey('unselected'),
                  color: Pallete.primary,
                ),
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            _isSelected ? Pallete.primary : Pallete.secondary.withAlpha(40),
          ),
          foregroundColor: WidgetStateProperty.all(
            _isSelected ? Colors.white : Pallete.primary,
          ),
        ),
      ),
    );
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });
    widget.onSelectionChanged?.call(_isSelected);
  }
}
