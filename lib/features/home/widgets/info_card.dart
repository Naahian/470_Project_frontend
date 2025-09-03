import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';

abstract class InfoCardType {
  static final String product = "Total Product";
  static final String stock = "Low Stock";
  static final String revenue = "Revenue";
  static final String category = "Total Category";
}

class InfoCard extends StatelessWidget {
  final String type;
  final double value;
  final bool isRevenue;

  const InfoCard({
    super.key,
    required this.type,
    required this.value,
    this.isRevenue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Pallete.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: _buildInfo()),
          Positioned(top: 50, left: 90, child: _buildIcon()),
        ],
      ),
    );
  }

  Padding _buildInfo() {
    final String formattedValue = formatValue(value);
    final String cardValue = type == InfoCardType.revenue
        ? '\$$formattedValue'
        : formattedValue;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          FittedBox(
            child: Text(
              cardValue,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Icon _buildIcon() {
    if (type == InfoCardType.revenue) {
      return Icon(
        Icons.monetization_on_outlined,
        size: 100,
        color: Pallete.secondary,
      );
    }
    if (type == InfoCardType.product) {
      return Icon(
        Icons.inventory_2_outlined,
        size: 100,
        color: Pallete.secondary,
      );
    }
    if (type == InfoCardType.category) {
      return Icon(Icons.category_outlined, size: 100, color: Pallete.secondary);
    }
    if (type == InfoCardType.stock) {
      return Icon(
        Icons.warehouse_outlined,
        size: 100,
        color: Pallete.secondary,
      );
    }
    return Icon(Icons.info_outline, size: 100, color: Pallete.secondary);
  }

  String formatValue(double val) {
    if (val > 100000) {
      String newVal = (val / 100000).toStringAsPrecision(3);
      return "${newVal}M";
    } else if (val > 1000) {
      String newVal = (val / 1000).toStringAsPrecision(3);
      ;
      return "${newVal}K";
    }
    return "$val";
  }
}
