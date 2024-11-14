import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app_movil/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test de integración completo para la aplicación',
      (WidgetTester tester) async {
    // Inicia la aplicación
    app.main();
    await tester.pumpAndSettle();

    // Verifica que estamos en la pantalla de bienvenida
    expect(find.text('Bienvenido a Fluxxr'), findsOneWidget);

    // Navega al login
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();

    // Verifica que estamos en la pantalla de login
    expect(find.text('Iniciar Sesión'), findsOneWidget);

    // Ingresa credenciales y realiza el login
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com'); // Email
    await tester.enterText(find.byType(TextField).at(1), 'password123'); // Contraseña
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verifica que estamos en el Home
    expect(find.text('FLUXX'), findsOneWidget);

    // Agrega una actividad booleana
    await tester.tap(find.byIcon(Icons.add)); // Botón de añadir
    await tester.pumpAndSettle();
    await tester.tap(find.text('Actividades Unicas'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nueva Actividad Unica');
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verifica que la actividad fue agregada
    expect(find.text('Nueva Actividad Unica'), findsOneWidget);

    // Agrega una actividad cuantitativa
    await tester.tap(find.byIcon(Icons.add)); // Botón de añadir
    await tester.pumpAndSettle();
    await tester.tap(find.text('Actividades Repetibles'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Nueva Actividad Cuantitativa');
    await tester.enterText(find.byType(TextField).last, '10'); // Cantidad esperada
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();

    // Verifica que la actividad fue agregada
    expect(find.text('Nueva Actividad Cuantitativa: 0 (Esperado: 10 veces)'),
        findsOneWidget);

    // Incrementa la actividad cuantitativa
    await tester.tap(find.byIcon(Icons.add).last); // Incrementar
    await tester.pumpAndSettle();
    expect(find.text('Nueva Actividad Cuantitativa: 1 (Esperado: 10 veces)'),
        findsOneWidget);

    // Añade puntos diarios al total
    await tester.tap(find.text('Añadir')); // Botón para sumar puntos
    await tester.pumpAndSettle();

    // Verifica que los puntos totales se han actualizado
    expect(find.textContaining('Puntos totales:'), findsOneWidget);

    // Cambia a la vista de usuario
    await tester.tap(find.byIcon(Icons.person)); // Navegación a usuario
    await tester.pumpAndSettle();

    // Verifica que estamos en la pantalla de usuario
    expect(find.text('Información del Usuario'), findsOneWidget);

    // Cierra sesión
    await tester.tap(find.text('Cerrar Sesión'));
    await tester.pumpAndSettle();

    // Verifica que estamos de vuelta en la pantalla de login
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
