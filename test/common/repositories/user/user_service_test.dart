import 'dart:io';

import 'package:delfitness/common/repositories/user/models/user.dart';
import 'package:delfitness/common/repositories/user/user_service.dart';
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
  group('UserService', () {
    late MockHttp httpClient;
    late UserService userService;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() async {
      httpClient = MockHttp();
      userService = UserService(httpClient: httpClient);
      SharedPreferences.setMockInitialValues(
          {"token": "bf48a000d0b9cc1f16fcd8c1935f129ed45ad52a"});
    });

    group('Constructor', () {
      test('Does not required a httpClient', () {
        expect(UserService(), isNotNull);
        expect(httpClient, isNotNull);
      });
    });

    group('Retrieve user - Bad Request', () {
      test(
          'Make http request with empty body,'
          ' throw [ErrorBadRequest]', () async {
        when(() => httpClient.get(any(), headers: any(named: "headers")))
            .thenAnswer((_) async => http.Response("{}", 400));
        User user = await userService.whoIAm();
        expect(user, User.empty);
      });

      test('Retrieve user - Ok Request', () async {
        when(() => httpClient.get(any(),
            headers:
                any(named: "headers"))).thenAnswer((_) async => http.Response(
            '{"id": 1, "username": "test", "email": "test@email.com", "firstName": "Pepe", "lastName": "García"}',
            200));
        User user = await userService.whoIAm();
        expect(
          user,
          isA<User>(),
        );
        expect(
            user,
            const User(
                id: 1,
                username: "test",
                email: "test@email.com",
                firstName: "Pepe",
                lastName: "García"));
      });
    });
  });
}
