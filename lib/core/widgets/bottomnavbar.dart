import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        elevation: 2,
        currentIndex: widget.currentIndex,
        onTap: (index) => onTap(index, context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Products'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Shipment',
          ),
        ],
      ),
    );
  }
}

void onTap(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go("/");
      break;
    case 1:
      context.go("/products");
      break;
    case 2:
      context.go("/category");
      break;
    case 3:
      break;
    case 4:
      break;
    default:
      SnackBar(content: Text("something went wrong."));
  }
}
