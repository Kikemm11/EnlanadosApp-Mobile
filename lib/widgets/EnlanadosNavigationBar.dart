import 'package:flutter/material.dart';

class EnlanadosNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const EnlanadosNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.cyan[50],
      selectedItemColor: currentIndex == -1 ? Colors.grey : Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex >= 0 ? currentIndex : 0,
      showUnselectedLabels: true,
      enableFeedback: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Estadísticas',
        ),
      ],
      onTap: onTap,
    );
  }
}
