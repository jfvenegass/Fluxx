import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_movil/controllers/activities_controller.dart';
import 'package:app_movil/pages/widgets/barra_navegacion.dart';
import 'package:app_movil/pages/widgets/progress_circle.dart';
import 'package:app_movil/pages/widgets/streak_widget.dart';
import 'package:app_movil/pages/widgets/welcome.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_movil/pages/widgets/add_daily_points_button.dart';
import 'package:app_movil/pages/widgets/activities_details.dart';

void main() {
  late ActivitiesController controller;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    controller = ActivitiesController();
    Get.put(controller);
  });

  tearDown(() {
    Get.delete<ActivitiesController>();
  });

  /////////////////////////// BarraNavegacion ///////////////////////////
  testWidgets('BarraNavegacion muestra los elementos correctamente',
      (WidgetTester tester) async {
    print(
        "Iniciando test: BarraNavegacion muestra los elementos correctamente");
    int selectedIndex = 0;
    final List<String> tappedItems = [];

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

    print("Verificando elementos de la Barra de Navegación...");
    expect(find.text('Añadir'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    print(
        "Test completado: BarraNavegacion muestra los elementos correctamente");
  });

  /////////////////////////// StreakWidget ///////////////////////////
  testWidgets('StreakWidget muestra la racha correctamente',
      (WidgetTester tester) async {
    print("Iniciando test: StreakWidget muestra la racha correctamente");
    controller.streak.value = 5;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: StreakWidget(),
        ),
      ),
    );

    print("Verificando que la racha sea visible...");
    expect(find.text('5'), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    print("Test completado: StreakWidget muestra la racha correctamente");
  });

  /////////////////////////// WelcomeScreen ///////////////////////////
  testWidgets('WelcomeScreen muestra los elementos correctamente',
      (WidgetTester tester) async {
    print("Iniciando test: WelcomeScreen muestra los elementos correctamente");
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: [
          GetPage(
              name: '/login',
              page: () => const Scaffold(body: Text('Login Screen'))),
        ],
        home: WelcomeScreen(),
      ),
    );

    print("Verificando elementos de WelcomeScreen...");
    expect(find.text('Bienvenido a Fluxxr'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    print("Test completado: WelcomeScreen muestra los elementos correctamente");
  });

  /////////////////////////// ProgressCircle ///////////////////////////
  testWidgets('ProgressCircle muestra 0.0% cuando no hay actividades',
      (WidgetTester tester) async {
    print(
        "Iniciando test: ProgressCircle muestra 0.0% cuando no hay actividades");
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ProgressCircle(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text("0.0%"), findsOneWidget);
    print(
        "Test completado: ProgressCircle muestra 0.0% cuando no hay actividades");
  });

  testWidgets('ProgressCircle muestra progreso correcto combinado',
      (WidgetTester tester) async {
    print("Iniciando test: ProgressCircle muestra progreso correcto combinado");
    controller.booleanActivities.addAll([
      {'Boolean Activity 1': true}, // 100% boolean progress
    ]);

    controller.quantitativeActivities.addAll([
      {
        'Quantitative Activity 1': {'initial': 10, 'current': 5}
      }, // 50% progress
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ProgressCircle(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text("75.0%"), findsOneWidget); // Cambiado a 75.0%
    print(
        "Test completado: ProgressCircle muestra progreso correcto combinado");
  });

  /////////////////////////// AddDailyPointsButton ///////////////////////////
  testWidgets('AddDailyPointsButton llama al método y resetea puntos diarios',
      (WidgetTester tester) async {
    print(
        "Iniciando test: AddDailyPointsButton llama al método y resetea puntos diarios");
    await tester.runAsync(() async {
      controller.dailyPoints.value = 10;
      controller.totalPoints.value = 50;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AddDailyPointsButton(),
          ),
        ),
      );

      print(
          "Valores iniciales: DailyPoints=${controller.dailyPoints.value}, TotalPoints=${controller.totalPoints.value}");
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      print(
          "Valores después del tap: DailyPoints=${controller.dailyPoints.value}, TotalPoints=${controller.totalPoints.value}");
      expect(controller.totalPoints.value, 60);
      expect(controller.dailyPoints.value, 0);
    });
    print(
        "Test completado: AddDailyPointsButton llama al método y resetea puntos diarios");
  });

  /////////////////////////// ActivitiesDetails ///////////////////////////
  testWidgets(
      'ActivitiesDetails incrementa y decrementa actividades cuantitativas',
      (WidgetTester tester) async {
    print(
        "Iniciando test: ActivitiesDetails incrementa y decrementa actividades cuantitativas");
    await tester.runAsync(() async {
      controller.quantitativeActivities.addAll([
        {
          'Quantitative Activity': {'initial': 10, 'current': 5}
        },
      ]);

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: ActivitiesDetails(controller: controller),
          ),
        ),
      );

      await tester.tap(find.text('Actividades Repetibles'));
      await tester.pumpAndSettle();

      print("Incrementando actividad cuantitativa...");
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(
          controller.quantitativeActivities
              .first['Quantitative Activity']!['current'],
          6);

      print("Decrementando actividad cuantitativa...");
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(
          controller.quantitativeActivities
              .first['Quantitative Activity']!['current'],
          5);
    });
    print(
        "Test completado: ActivitiesDetails incrementa y decrementa actividades cuantitativas");
  });
}
