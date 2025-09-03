import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/category/controllers/category_controller.dart';
import 'package:inventory_management_app/features/category/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTile extends StatelessWidget {
  final bool delivered;
  final CategoryModel category;

  const CategoryTile({
    super.key,
    required this.category,
    required this.delivered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: _categoryImage(),
            title: Text(category.name, style: TextStyle(fontSize: 18)),
            subtitle: _info(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_refillButton(), _deleteButton()],
            ),
          ),
        ],
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
    Color progressColor;
    switch (category.quantity) {
      case < 30:
        progressColor = Pallete.error;
        break;
      case < 80:
        progressColor = Pallete.warning;
        break;
      default:
        progressColor = Pallete.success;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: category.quantity / 100,
          minHeight: 10,
          borderRadius: BorderRadius.circular(10),
          color: progressColor,
        ),
        SizedBox(height: 5),
        Text("${category.quantity} items left"),
        SizedBox(height: 5),
      ],
    );
  }

  OutlinedButton _refillButton() => OutlinedButton(
    onPressed: delivered ? () {} : null,
    child: Text("Refill"),
  );

  Widget _deleteButton() {
    return Consumer(
      builder: (context, ref, _) {
        return TextButton(
          onPressed: () {
            ref
                .read(categoryControllerProvider.notifier)
                .deleteCategory(category.id.toString());
          },
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: Text("Delete"),
        );
      },
    );
  }
}
