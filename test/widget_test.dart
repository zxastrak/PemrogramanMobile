import 'package:flutter_test/flutter_test.dart';
import 'package:pbl_uas_inventory/main.dart';

void main() {
  testWidgets('Warehouse app smoke test - Login and Navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('WAREHOUSE SYSTEM'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);

    await tester.tap(find.text('Masuk'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('MAP'), findsOneWidget);
    expect(find.text('Tugas Hari Ini'), findsOneWidget);
  });
}
