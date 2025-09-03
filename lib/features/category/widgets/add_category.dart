import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/category/controllers/category_controller.dart';

import '../models/category_model.dart';

class AddCategorPopup extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController iconController = TextEditingController();

  AddCategorPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),

            DropdownButtonFormField<String>(
              value: iconController.text.isNotEmpty
                  ? iconController.text
                  : null,
              decoration: const InputDecoration(labelText: 'Icon'),
              items: [
                DropdownMenuItem(value: '0', child: Text('Home')),
                DropdownMenuItem(value: '1', child: Text('Work')),
                DropdownMenuItem(value: '2', child: Text('School')),
                DropdownMenuItem(value: '3', child: Text('Shopping')),
              ],
              onChanged: (value) {
                iconController.text = value ?? '';
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (context, ref, _) {
            return ElevatedButton(
              onPressed: () async {
                final newCategory = CategoryModel(
                  id: null,
                  name: nameController.text,
                  imageNo: int.parse(iconController.text),
                  quantity: int.parse(quantityController.text),
                );

                await ref
                    .read(categoryControllerProvider.notifier)
                    .addCategory(newCategory);

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            );
          },
        ),
      ],
    );
  }
}
