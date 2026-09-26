import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';

void main() {
  testWidgets('My app builds successfully', (tester) async {
    await tester.pumpWidget(const JovaApp());
    await tester.pumpAndSettle();

    expect(find.byType(JovaApp), findsOneWidget);
  });
}
