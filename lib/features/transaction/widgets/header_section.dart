import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/transaction/controller/transaction_controller.dart';

class HeaderSection extends ConsumerStatefulWidget {
  const HeaderSection({super.key});

  @override
  ConsumerState<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<HeaderSection>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Pallete.primary,
      child: Column(children: [_buildSearchBar(), _buildTabBar()]),
    );
  }

  Container _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),

      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Sales'),
          Tab(text: 'Orders'),
        ],
        onTap: (value) => ref
            .read(transactionControllerProvider.notifier)
            .updateFilter(value),
      ),
    );
  }

  Padding _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          onChanged: (value) {
            ref
                .read(transactionControllerProvider.notifier)
                .updateSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
