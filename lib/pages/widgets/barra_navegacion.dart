import 'package:flutter/material.dart';

class BarraNavegacion extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BarraNavegacion({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.help_outline),
          label: 'Info',
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
        // Llama a la función proporcionada para manejar el cambio de índice
        onItemTapped(index);
      },
    );
  }
}

