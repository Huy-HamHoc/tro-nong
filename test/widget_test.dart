import 'package:flutter_test/flutter_test.dart';
import 'package:tro_nong/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TroNongApp());
    expect(find.text('Trợ Nông'), findsOneWidget);
  });
}
