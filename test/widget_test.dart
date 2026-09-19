import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';

void main() {
  testWidgets('Jecord app builds successfully', (tester) async {
    await tester.pumpWidget(const JecordApp());
    await tester.pumpAndSettle();

    expect(find.byType(JecordApp), findsOneWidget);
  });
}
