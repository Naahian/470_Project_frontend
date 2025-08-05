import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/category/controllers/category_controller.dart';
import 'package:inventory_management_app/features/category/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});

  final CategoryModel category;

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
      child: ListTile(
        leading: _categoryImage(),
        title: Text(category.name, style: TextStyle(fontSize: 18)),
        subtitle: _info(),
        trailing: _deleteButton(),
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

  Widget _deleteButton() {
    return Consumer(
      builder: (context, ref, _) {
        return IconButton(
          onPressed: () {
            ref
                .read(categoryControllerProvider.notifier)
                .deleteCategory(category.id.toString());
          },
          icon: Icon(Icons.delete_outline),
          color: Pallete.error,
        );
      },
    );
  }
}
