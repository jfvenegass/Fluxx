import 'package:flutter/material.dart';

class BarraNavegacion extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onAddButtonPressed;

  const BarraNavegacion({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onAddButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Añadir',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Usuario',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 0) {
          onAddButtonPressed();
        } else {
          onItemTapped(index);
        }
      },
    );
  }
}


