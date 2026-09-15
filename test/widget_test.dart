import 'package:flutter_test/flutter_test.dart';
import 'package:kelpico/kelpico_app.dart';

void main() {
  testWidgets('KelpicoApp drawer smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KelpicoApp());
    expect(find.text('Pantry Shelves'), findsOneWidget);
  });
}
