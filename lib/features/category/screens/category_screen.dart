import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';
import 'package:inventory_management_app/features/category/controllers/category_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/widgets.dart';

class CategoryScreen extends ConsumerWidget {
  CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryControllerProvider);

    return Scaffold(
      appBar: _buildAppbar(),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Pallete.background],
          ),
        ),
        child: Stack(
          children: [
            _bgIcon1(),
            _bgIcon2(),
            Padding(
              padding: const EdgeInsets.all(25),
              child: categoryState.isLoading
                  ? _buildLoaing()
                  : _buildCategories(categoryState.categories),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.primary,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddCategorPopup(),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title: const Text('CATEGORY'),
      foregroundColor: Colors.white,
      centerTitle: true,
      backgroundColor: Pallete.primary,
    );
  }

  Widget? _buildLoaing() => const Center(child: CircularProgressIndicator());

  Widget? _buildCategories(categories) => ListView.builder(
    itemCount: categories.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: CategoryTile(category: categories[index], delivered: false),
      );
    },
  );

  Positioned _bgIcon2() {
    return Positioned(
      right: -60,
      bottom: 50,
      child: Icon(Icons.category_outlined, color: Pallete.secondary, size: 240),
    );
  }

  Positioned _bgIcon1() {
    return Positioned(
      left: -180,
      top: 0,
      child: Icon(Icons.category_outlined, color: Pallete.secondary, size: 380),
    );
  }
}
