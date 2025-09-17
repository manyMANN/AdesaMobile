import 'package:flutter/material.dart';

class AdesaNavBar extends StatelessWidget {
  //VARIABLES
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  //CONSTRUCTO (INICIAR LAS VARIABLES)
  const AdesaNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  BottomNavigationBarItem buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey[600]),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 0,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey[600],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        buildNavItem(icon: Icons.article, label: 'Pedidos', index: 0),
        buildNavItem(icon: Icons.groups_sharp, label: 'Clientes', index: 1),
        buildNavItem(icon: Icons.storefront, label: 'Catálogo', index: 2),
        buildNavItem(
          icon: Icons.currency_exchange,
          label: 'Finanzas',
          index: 3,
        ),
        buildNavItem(icon: Icons.menu, label: 'Menú', index: 4),
      ],
    );
  }
}
