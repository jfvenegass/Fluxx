// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_movil/main.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/widgets/puntos.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';
import 'package:app_movil/pages/widgets/progress_circle.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:app_movil/pages/widgets/streak_widget.dart';
import 'package:app_movil/pages/widgets/welcome.dart';


void main() {

  /////////////////////////// barra_navegacion ///////////////////////////
  testWidgets('BarraNavegacion displays items correctly', (WidgetTester tester) async {
    // Arrange
    int selectedIndex = 0;
    final List<String> tappedItems = [];

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BarraNavegacion(
            selectedIndex: selectedIndex,
            onItemTapped: (index) {
              tappedItems.add('Tapped: $index');
            },
            onAddButtonPressed: () {
              tappedItems.add('Add button pressed');
            },
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Añadir'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('BarraNavegacion triggers onAddButtonPressed when Añadir is tapped', (WidgetTester tester) async {
    // Arrange
    int selectedIndex = 0;
    bool addButtonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BarraNavegacion(
            selectedIndex: selectedIndex,
            onItemTapped: (_) {},
            onAddButtonPressed: () {
              addButtonPressed = true;
            },
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Assert
    expect(addButtonPressed, isTrue);
  });

  testWidgets('BarraNavegacion triggers onItemTapped for Home and Usuario', (WidgetTester tester) async {
    // Arrange
    int selectedIndex = 0;
    final List<int> tappedIndices = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BarraNavegacion(
            selectedIndex: selectedIndex,
            onItemTapped: (index) {
              tappedIndices.add(index);
            },
            onAddButtonPressed: () {},
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Assert
    expect(tappedIndices, [1, 2]);
  });

  /////////////////////////// progress_circle ///////////////////////////

}

