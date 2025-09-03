import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';
import 'package:inventory_management_app/features/products/controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  bool _initialFetchDone = false;

  @override
  void initState() {
    super.initState();
    // Fetch products when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(productControllerProvider.notifier);
      controller.fetchAllProducts();
      _initialFetchDone = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Optional: Fetch products every time the screen becomes visible
    if (_initialFetchDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = ref.read(productControllerProvider.notifier);
        controller.fetchAllProducts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);
    final controller = ref.read(productControllerProvider.notifier);

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      floatingActionButton: _floatingAddButtons(context, controller),
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
                ProductHeaderSection(controller: controller),
                const SizedBox(height: 16),
                // Product List
                Expanded(child: _buildContent(state, controller)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      foregroundColor: Colors.white,
      centerTitle: true,
      title: const Text('Products'),
      backgroundColor: Pallete.primary,
    );
  }

  Widget _floatingAddButtons(
    BuildContext context,
    ProductController controller,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: Pallete.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15),
            ),
            elevation: 5,
            padding: EdgeInsets.all(16),
          ),
          child: Text(
            "Checkout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ProductState state, ProductController controller) {
    if (state.hasError && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.error}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.fetchAllProducts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredProducts = state.filteredProducts;

    if (filteredProducts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No products found'),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchAllProducts(),
      child: _buildProductList(filteredProducts),
    );
  }

  ListView _buildProductList(List<ProductModel> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: ProductTile(product: product),
        );
      },
    );
  }
}
