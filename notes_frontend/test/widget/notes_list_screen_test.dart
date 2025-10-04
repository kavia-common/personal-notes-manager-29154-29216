import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_frontend/main.dart';

void main() {
  testWidgets('Notes list shows FAB and navigates to editor', (tester) async {
    await tester.pumpWidget(const NotesApp());
    await tester.pumpAndSettle();

    // FAB exists
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap FAB -> editor
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Edit note'), findsOneWidget);

    // Type title and save
    await tester.enterText(find.byType(TextField).first, 'Test Note');
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Save'));
    await tester.pumpAndSettle();

    // Back on list
    expect(find.text('Notes'), findsOneWidget);
  });
}
