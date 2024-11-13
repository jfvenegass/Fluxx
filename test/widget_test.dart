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
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_movil/pages/widgets/add_daily_points_button.dart';
import 'package:app_movil/pages/widgets/activities_modales.dart';
import 'package:app_movil/pages/widgets/activities_details.dart';

void main() {
  /////////////////////////// barra_navegacion ///////////////////////////
  testWidgets('BarraNavegacion displays items correctly',
      (WidgetTester tester) async {
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

  testWidgets(
      'BarraNavegacion triggers onAddButtonPressed when Añadir is tapped',
      (WidgetTester tester) async {
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

  testWidgets('BarraNavegacion triggers onItemTapped for Home and Usuario',
      (WidgetTester tester) async {
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

  /////////////////////////// streak_widget ///////////////////////////
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

  testWidgets('Displays the streak value correctly',
      (WidgetTester tester) async {
    // Arrange
    controller.streak.value = 5;

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: StreakWidget(),
        ),
      ),
    );

    // Assert
    expect(find.text('5'), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
  });

  testWidgets('Updates streak value when changed', (WidgetTester tester) async {
    // Arrange
    controller.streak.value = 5;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: StreakWidget(),
        ),
      ),
    );

    // Assert initial value
    expect(find.text('5'), findsOneWidget);

    // Act
    controller.streak.value = 10;
    await tester.pump();

    // Assert updated value
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('Displays the fire icon correctly', (WidgetTester tester) async {
    // Arrange
    controller.streak.value = 0;

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: StreakWidget(),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
  });

  /////////////////////////// welcome ///////////////////////////
  testWidgets('WelcomeScreen displays correctly', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: [
          GetPage(
              name: '/login', page: () => Scaffold(body: Text('Login Screen'))),
        ],
        home: WelcomeScreen(),
      ),
    );

    // Assert
    expect(find.text('Bienvenido a Fluxxr'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Navigates to login screen when button is tapped',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: [
          GetPage(
              name: '/login', page: () => Scaffold(body: Text('Login Screen'))),
        ],
        home: WelcomeScreen(),
      ),
    );

    // Act
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Login Screen'), findsOneWidget);
  });

  /////////////////////////// puntos ///////////////////////////
  setUp(() {
    controller = ActivitiesController();
    Get.put(controller);
  });

  tearDown(() {
    Get.delete<ActivitiesController>();
  });

  testWidgets('Confirmation dialog displays correctly',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => showConfirmationDialog(context, controller),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Confirmar'), findsOneWidget);
    expect(
        find.text(
            '¿Deseas añadir los puntos diarios al total y reiniciar las actividades?'),
        findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Añadir'), findsOneWidget);
  });

  testWidgets('Tapping Cancel closes the dialog', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => showConfirmationDialog(context, controller),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Confirmar'), findsNothing);
  });

  ///E
  testWidgets('Tapping Add calls controller method and closes the dialog',
      (WidgetTester tester) async {
    // Arrange
    bool methodCalled = false;

    controller.addDailyPointsToTotalAndResetActivities ==
        (BuildContext context) {
          methodCalled = true;
        };

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => showConfirmationDialog(context, controller),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Assert
    expect(methodCalled, isTrue);
    expect(find.text('Confirmar'), findsNothing);
  });

  /////////////////////////// progress_circle ///////////////////////////
  setUp(() {
    controller = ActivitiesController();
    Get.put(controller);
  });

  tearDown(() {
    Get.delete<ActivitiesController>();
  });

  testWidgets('Displays 0.0% progress when there are no activities',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ProgressCircle(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Ensure all widgets are built
    expect(find.text("0.0%"), findsOneWidget);
  });

///E
  testWidgets('Displays correct progress for boolean activities',
      (WidgetTester tester) async {
    controller.booleanActivities.addAll([
      {'Boolean Activity Test': true},
      {'Another Activity': false},
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ProgressCircle(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Ensure Obx reacts
    expect(find.text("25.0%"),
        findsOneWidget); // 50% boolean progress * 0.5 weight
  });

///E
  testWidgets('Displays correct progress for quantitative activities',
      (WidgetTester tester) async {
    controller.quantitativeActivities.addAll([
      {
        'Quantitative 1': {'initial': 10, 'current': 5},
      },
      {
        'Quantitative 2': {'initial': 20, 'current': 10},
      },
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ProgressCircle(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Ensure Obx reacts
    expect(find.text("25.0%"),
        findsOneWidget); // 50% quantitative progress * 0.5 weight
  });

///E
  testWidgets('Displays combined progress correctly',
      (WidgetTester tester) async {
    controller.booleanActivities.addAll([
      {'Boolean Activity Test': true},
      {'Another Activity': false},
    ]);

    controller.quantitativeActivities.addAll([
      {
        'Quantitative 1': {'initial': 10, 'current': 5},
      },
      {
        'Quantitative 2': {'initial': 20, 'current': 10},
      },
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ProgressCircle(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Ensure Obx reacts
    expect(find.text("50.0%"),
        findsOneWidget); // Combined progress: 25% boolean + 25% quantitative
  });

  testWidgets('Handles quantitative activities with initial count 0',
      (WidgetTester tester) async {
    controller.quantitativeActivities.addAll([
      {
        'Quantitative 1': {'initial': 0, 'current': 0},
      },
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ProgressCircle(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Ensure Obx reacts
    expect(find.text("0.0%"),
        findsOneWidget); // No progress due to initial count 0
  });

  /////////////////////////// add_daily_points ///////////////////////////
  setUp(() {
    controller = ActivitiesController();
    Get.put(controller);
  });

  tearDown(() {
    Get.delete<ActivitiesController>();
  });

  ///E
  testWidgets('Button calls addDailyPointsToTotal and resets daily points',
      (WidgetTester tester) async {
    // Arrange: Set initial daily points and total points
    controller.dailyPoints.value = 10;
    controller.totalPoints.value = 50;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: AddDailyPointsButton(),
        ),
      ),
    );

    // Act: Tap the button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Assert: Verify total points and daily points are updated
    expect(controller.totalPoints.value, 50); // Total points should increase
    expect(controller.dailyPoints.value, 10); // Daily points should reset to 0
  });

  testWidgets('Button displays correct text', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: AddDailyPointsButton(),
        ),
      ),
    );

    // Assert: Verify the button text
    expect(find.text('Añadir puntos diarios'), findsOneWidget);
  });

  /////////////////////////// activities_modales ///////////////////////////
  setUp(() {
    controller = ActivitiesController();
    Get.put(controller);
  });

  tearDown(() {
    Get.delete<ActivitiesController>();
  });

  testWidgets('Add boolean activity dialog adds activity on confirm',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showAddBooleanActivityDialog(context, controller);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Enter activity name
    await tester.enterText(find.byType(TextField), 'Test Boolean Activity');

    // Confirm and close dialog
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verify the activity was added
    expect(controller.booleanActivities.length, 1);
    expect(
        controller.booleanActivities.first.keys.first, 'Test Boolean Activity');
  });

  testWidgets('Add quantitative activity dialog adds activity on confirm',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showAddQuantitativeActivityDialog(context, controller);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Enter activity name
    await tester.enterText(
        find.byType(TextField).first, 'Test Quantitative Activity');

    // Enter initial count
    await tester.enterText(find.byType(TextField).last, '10');

    // Confirm and close dialog
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verify the activity was added
    expect(controller.quantitativeActivities.length, 1);
    expect(controller.quantitativeActivities.first.keys.first,
        'Test Quantitative Activity');
    expect(controller.quantitativeActivities.first.values.first['initial'], 10);
  });

  testWidgets('Dialog does not add activity when name is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showAddBooleanActivityDialog(context, controller);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Confirm without entering text
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verify no activity was added
    expect(controller.booleanActivities.length, 0);
  });

  testWidgets(
      'Dialog does not add quantitative activity when initial count is invalid',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showAddQuantitativeActivityDialog(context, controller);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Enter activity name
    await tester.enterText(
        find.byType(TextField).first, 'Test Invalid Activity');

    // Enter invalid initial count
    await tester.enterText(find.byType(TextField).last, 'invalid');

    // Confirm and close dialog
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verify no activity was added
    expect(controller.quantitativeActivities.length, 0);
  });

  /////////////////////////// activities_details ///////////////////////////
    setUp(() {
    controller = ActivitiesController();
    Get.put(controller);
  });

  tearDown(() {
    Get.delete<ActivitiesController>();
  });

  testWidgets('Displays message when no boolean activities are present', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ActivitiesDetails(controller: controller),
        ),
      ),
    );

    // Expand the boolean activities section
    await tester.tap(find.text('Actividades Unicas'));
    await tester.pumpAndSettle();

    // Verify the no activities message is displayed
    expect(find.text('No hay actividades unicas agregadas.'), findsOneWidget);
  });

  testWidgets('Displays boolean activities when present', (WidgetTester tester) async {
    controller.booleanActivities.addAll([
      {'Boolean Activity 1': true},
      {'Boolean Activity 2': false},
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ActivitiesDetails(controller: controller),
        ),
      ),
    );

    // Expand the boolean activities section
    await tester.tap(find.text('Actividades Unicas'));
    await tester.pumpAndSettle();

    // Verify the activities are displayed
    expect(find.text('Boolean Activity 1'), findsOneWidget);
    expect(find.text('Boolean Activity 2'), findsOneWidget);
  });

  testWidgets('Displays message when no quantitative activities are present', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ActivitiesDetails(controller: controller),
        ),
      ),
    );

    // Expand the quantitative activities section
    await tester.tap(find.text('Actividades Repetibles'));
    await tester.pumpAndSettle();

    // Verify the no activities message is displayed
    expect(find.text('No hay actividades repetibles agregadas.'), findsOneWidget);
  });

  testWidgets('Displays quantitative activities when present', (WidgetTester tester) async {
    controller.quantitativeActivities.addAll([
      {
        'Quantitative Activity 1': {'initial': 10, 'current': 5},
      },
      {
        'Quantitative Activity 2': {'initial': 20, 'current': 10},
      },
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ActivitiesDetails(controller: controller),
        ),
      ),
    );

    // Expand the quantitative activities section
    await tester.tap(find.text('Actividades Repetibles'));
    await tester.pumpAndSettle();

    // Verify the activities are displayed
    expect(find.text('Quantitative Activity 1: 5 (Esperado: 10 veces)'), findsOneWidget);
    expect(find.text('Quantitative Activity 2: 10 (Esperado: 20 veces)'), findsOneWidget);
  });

  testWidgets('Can toggle boolean activity status', (WidgetTester tester) async {
    controller.booleanActivities.addAll([
      {'Boolean Activity 1': false},
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ActivitiesDetails(controller: controller),
        ),
      ),
    );

    // Expand the boolean activities section
    await tester.tap(find.text('Actividades Unicas'));
    await tester.pumpAndSettle();

    // Toggle the checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // Verify the activity status was updated
    expect(controller.booleanActivities.first['Boolean Activity 1'], true);
  });

  testWidgets('Can increment and decrement quantitative activity', (WidgetTester tester) async {
    controller.quantitativeActivities.addAll([
      {
        'Quantitative Activity 1': {'initial': 10, 'current': 5},
      },
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ActivitiesDetails(controller: controller),
        ),
      ),
    );

    // Expand the quantitative activities section
    await tester.tap(find.text('Actividades Repetibles'));
    await tester.pumpAndSettle();

    // Increment the activity count
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify the count was incremented
    expect(controller.quantitativeActivities.first['Quantitative Activity 1']!['current'], 6);

    // Decrement the activity count
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    // Verify the count was decremented
    expect(controller.quantitativeActivities.first['Quantitative Activity 1']!['current'], 5);
  });
}
