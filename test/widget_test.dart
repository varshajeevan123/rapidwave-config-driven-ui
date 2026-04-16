import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapidweave/main.dart';

void main() {
  testWidgets('Load config driven app', (WidgetTester tester) async {
    // Build our app under ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: RapidWeaveApp()));

    // RapidWeave loads default configs asynchronously.
    // Ensure we can see some text rendering.
    await tester.pumpAndSettle();
  });
}
