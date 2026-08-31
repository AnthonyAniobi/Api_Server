import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:api_server/app.dart';
import 'package:api_server/core/constants/app_strings.dart';

void main() {
  testWidgets('Home page renders the app title and empty state',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.noEndpointTitle), findsOneWidget);
  });

  testWidgets('Add button offers Add Manually and Import Schema',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.addManually), findsOneWidget);
    expect(find.text(AppStrings.importSchema), findsOneWidget);
  });

  testWidgets('Add Manually creates an endpoint visible in the sidebar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.addManually));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Users');
    await tester.enterText(find.widgetWithText(TextField, 'Url'), '/users');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Users'), findsOneWidget);
    expect(find.text('/users'), findsOneWidget);
    expect(find.text(AppStrings.noEndpointTitle), findsNothing);
  });

  testWidgets('Starting the server without endpoints shows an alert',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.noEndpointDialogTitle), findsOneWidget);
  });
}
