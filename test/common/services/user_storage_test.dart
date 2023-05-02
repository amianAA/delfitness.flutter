import 'dart:io';

import 'package:delfitness/common/services/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHttp extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env/.local').readAsStringSync());
  group('UserStorage', () {
    late UserStorage userStorage;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      userStorage = await UserStorage.getInstance();
    });

    group('Init storage', () {
      test('Init class method return a <SharedPreferences> object', () async {
        expect(userStorage, isA<UserStorage>());
      });

      test('setString class method set the value correctly', () async {
        bool result = await userStorage.setString("token", "awesomeToken");
        expect(result, true);

        String? tokenValue = await userStorage.getString("token");
        expect(tokenValue, isA<String>());
        expect(tokenValue, "awesomeToken");
      });
    });
  });
}
