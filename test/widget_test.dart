import 'package:flutter_test/flutter_test.dart';
import 'package:kelpico/kelpico_scaffold.dart';

void main() {
  testWidgets('KelpicoApp launches successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KelpicoApp());
    expect(find.byType(KelpicoApp), findsOneWidget);
  });
}