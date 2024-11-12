// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_movil/main.dart';
import 'package:app_movil/pages/widgets/puntos.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';
import 'package:app_movil/pages/widgets/progress_circle.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:app_movil/pages/widgets/streak_widget.dart';
import 'package:app_movil/pages/widgets/welcome.dart';


// puntos.dart
void main() {
  testWidgets('Muestra el diálogo de confirmación y prueba las acciones', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showConfirmationDialog(context),
                  child: const Text('Abrir diálogo'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Simula presionar el botón para abrir el diálogo
    await tester.tap(find.text('Abrir diálogo'));
    await tester.pumpAndSettle();

    // Verifica que el diálogo se muestra con el título y contenido esperados
    expect(find.text('Confirmar'), findsOneWidget);
    expect(find.text('¿Deseas añadir los puntos diarios al total?'), findsOneWidget);

    // Verifica que los botones "Cancelar" y "Añadir" están presentes
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Añadir'), findsOneWidget);

    // Simula la interacción con el botón "Cancelar"
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    // Verifica que el diálogo se ha cerrado después de presionar "Cancelar"
    expect(find.text('Confirmar'), findsNothing);

    // Vuelve a abrir el diálogo
    await tester.tap(find.text('Abrir diálogo'));
    await tester.pumpAndSettle();

    // Simula la interacción con el botón "Añadir"
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verifica que el diálogo se ha cerrado después de presionar "Añadir"
    expect(find.text('Confirmar'), findsNothing);
  });



//barra_navegacion.dart
  testWidgets('Verifica que se muestra correctamente el ítem seleccionado', (WidgetTester tester) async {
    int selectedIndex = 1; // Ítem seleccionado al inicio
    await tester.pumpWidget(
      MaterialApp(
        home: BarraNavegacion(
          selectedIndex: selectedIndex,
          onItemTapped: (_) {},
          onAddButtonPressed: () {},
        ),
      ),
    );

    // Verifica que el ítem de inicio esté seleccionado
    final homeIcon = find.byIcon(Icons.home);
    expect(homeIcon, findsOneWidget);
    final homeText = find.text('Home');
    expect(homeText, findsOneWidget);
  });

  testWidgets('Verifica que el callback onAddButtonPressed se llama al seleccionar el botón "Añadir"', (WidgetTester tester) async {
    bool addButtonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BarraNavegacion(
          selectedIndex: 1,
          onItemTapped: (_) {},
          onAddButtonPressed: () {
            addButtonPressed = true;
          },
        ),
      ),
    );

    // Simula la interacción con el botón "Añadir"
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verifica que se ha llamado al callback onAddButtonPressed
    expect(addButtonPressed, isTrue);
  });

  testWidgets('Verifica que el callback onItemTapped se llama correctamente al seleccionar otros ítems', (WidgetTester tester) async {
    int tappedIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: BarraNavegacion(
          selectedIndex: 1,
          onItemTapped: (index) {
            tappedIndex = index;
          },
          onAddButtonPressed: () {},
        ),
      ),
    );

    // Simula la interacción con el botón "Usuario"
    await tester.tap(find.text('Usuario'));
    await tester.pumpAndSettle();

    // Verifica que se ha llamado al callback onItemTapped con el índice correcto
    expect(tappedIndex, 2);
  });

//progress_circle.dart
  testWidgets('Muestra el porcentaje correcto en el centro del indicador', (WidgetTester tester) async {
    // Proporciona un valor de progreso para el test
    const progressValue = 0.75; // 75%

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressCircle(progress: progressValue),
        ),
      ),
    );

    // Verifica que se muestra el porcentaje correcto en el centro del indicador
    expect(find.text('75.0%'), findsOneWidget);
  });

  testWidgets('Clampa el valor de progreso entre 0.0 y 1.0', (WidgetTester tester) async {
    // Proporciona un valor de progreso fuera del rango permitido
    const progressValue = 1.5; // Más de 100%

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressCircle(progress: progressValue),
        ),
      ),
    );

    // Verifica que el porcentaje se clampa a 100.0%
    expect(find.text('100.0%'), findsOneWidget);

    // Repite con un valor negativo
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressCircle(progress: -0.5),
        ),
      ),
    );

    // Verifica que el porcentaje se clampa a 0.0%
    expect(find.text('0.0%'), findsOneWidget);
  });

  testWidgets('Verifica el color y la configuración del indicador', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressCircle(progress: 0.5),
        ),
      ),
    );

    // Verifica que el widget CircularPercentIndicator esté presente
    expect(find.byType(CircularPercentIndicator), findsOneWidget);

    // Verifica que el color del progreso sea el configurado
    final circularPercentIndicator = tester.widget<CircularPercentIndicator>(find.byType(CircularPercentIndicator));
    expect(circularPercentIndicator.progressColor, Colors.teal);
    expect(circularPercentIndicator.backgroundColor, Colors.grey[300]);
    expect(circularPercentIndicator.circularStrokeCap, CircularStrokeCap.round);
  });

  // streak_widget.dart

  testWidgets('Muestra el ícono de fuego y el número de la racha correctamente', (WidgetTester tester) async {
    const streakValue = 5; // Número de la racha

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StreakWidget(streak: streakValue),
        ),
      ),
    );

    // Verifica que el ícono de fuego esté presente
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);

    // Verifica que el texto del número de la racha esté presente y sea correcto
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('Verifica el estilo de texto del número de la racha', (WidgetTester tester) async {
    const streakValue = 10;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StreakWidget(streak: streakValue),
        ),
      ),
    );

    // Encuentra el widget de texto que muestra el número de la racha
    final textWidget = tester.widget<Text>(find.text('10'));

    // Verifica el estilo de texto
    expect(textWidget.style?.fontSize, 18);
    expect(textWidget.style?.fontWeight, FontWeight.bold);
  });

  //welcome.dart
  testWidgets('Muestra el mensaje de bienvenida y el botón "Comenzar"', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    // Verifica que el texto de bienvenida esté presente
    expect(find.text('Bienvenido a Fluxx'), findsOneWidget);

    // Verifica que el botón "Comenzar" esté presente
    expect(find.text('Comenzar'), findsOneWidget);
  });

  testWidgets('Navega a la pantalla de inicio de sesión al presionar el botón "Comenzar"', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/login': (context) => const Scaffold(body: Center(child: Text('Pantalla de Inicio de Sesión'))),
        },
      ),
    );

    // Verifica que estamos en WelcomeScreen
    expect(find.text('Bienvenido a Fluxx'), findsOneWidget);

    // Simula la interacción con el botón "Comenzar"
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();

    // Verifica que la navegación fue exitosa y estamos en la pantalla de inicio de sesión
    expect(find.text('Pantalla de Inicio de Sesión'), findsOneWidget);
  });
}

