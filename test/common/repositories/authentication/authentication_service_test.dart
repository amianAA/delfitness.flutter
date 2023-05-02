import 'dart:io';

import 'package:delfitness/common/repositories/authentication/authentication_service.dart';
import 'package:delfitness/common/repositories/authentication/models/errors.dart';
import 'package:delfitness/common/repositories/authentication/models/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttp extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env/.local').readAsStringSync());
  group('AuthenticationService', () {
    late MockHttp httpClient;
    late AuthenticationService authService;
    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttp();
      authService = AuthenticationService(httpClient: httpClient);
    });

    group('Constructor', () {
      test('Does not required a httpClient', () {
        expect(AuthenticationService(), isNotNull);
        expect(httpClient, isNotNull);
      });
    });

    group('Perform login', () {
      test(
          'Make bad http request with empty body,'
          ' throw [ErrorBadRequest]', () async {
        when(() => httpClient.post(any(),
                body: any(named: "body"), headers: any(named: "headers")))
            .thenAnswer((_) async => http.Response("{}", 400));
        try {
          await authService.logIn(username: "", password: "");
          fail('should throw error bad request');
        } catch (error) {
          expect(
            error,
            ErrorBadRequest,
          );
        }
      });
      test('Unreachable server throw [ErrorUnreachable]', () async {
        when(() => httpClient.post(any(),
                body: any(named: "body"), headers: any(named: "headers")))
            .thenAnswer((_) async => http.Response("{}", 502));
        try {
          await authService.logIn(username: "", password: "");
          fail('should throw error bad request');
        } catch (error) {
          expect(
            error,
            ErrorUnreachable,
          );
        }
      });

      test('Return token on valid response', () async {
        when(() => httpClient.post(any(),
                body: any(named: "body"), headers: any(named: "headers")))
            .thenAnswer((_) async => http.Response(
                '{"token": "bf48a000d0b9cc1f16fcd8c1935f129ed45ad52a"}', 200));
        UserToken userToken =
            await authService.logIn(username: "user", password: "pass");
        expect(
          userToken,
          isA<UserToken>(),
        );
        expect(userToken.token, "bf48a000d0b9cc1f16fcd8c1935f129ed45ad52a");
      });
    });
    group('Models', () {
      test('Return props on UserToken model', () async {
        UserToken userToken =
            const UserToken(token: "bf48a000d0b9cc1f16fcd8c1935f129ed45ad52a");
        expect(
          userToken.props,
          isA<List<Object>>(),
        );
        expect(userToken.props[0], "bf48a000d0b9cc1f16fcd8c1935f129ed45ad52a");
      });
    });
  });
}
