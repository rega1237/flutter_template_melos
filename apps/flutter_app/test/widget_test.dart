import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App renders home page with confirmation message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify the template confirmation message is shown
    expect(find.text('Entorno Totalmente Instalado'), findsOneWidget);
  });
}
