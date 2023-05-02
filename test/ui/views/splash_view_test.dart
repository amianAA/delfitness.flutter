import 'package:delfitness/ui/views/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {});
  group('Splash Page', () {
    setUp(() {});

    test('Splash page route returns a page Route', () {
      expect(SplashPage.route(), isA<Route>());
    });

    testWidgets('Splash page build returns a page Route', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SplashPage(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
