import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:watermelon/main.dart';

void main() {
  testWidgets('App boots on the onboarding screen', (tester) async {
    // Use a realistic phone surface (the design targets 390×844 portrait).
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: WatermelonApp()));
    await tester.pump();

    expect(find.text("Get started — it's free"), findsOneWidget);
    expect(find.text('WATERMELON'), findsOneWidget);
  });
}
