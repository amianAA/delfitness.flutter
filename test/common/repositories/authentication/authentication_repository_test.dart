import 'dart:async';
import 'dart:io';

import 'package:delfitness/common/repositories/authentication/authentication_repository.dart';
import 'package:delfitness/common/repositories/authentication/authentication_service.dart';
import 'package:delfitness/common/repositories/authentication/models/errors.dart';
import 'package:delfitness/common/repositories/authentication/models/token.dart';
import 'package:delfitness/common/services/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService extends Mock implements AuthenticationService {}

class FakeUri extends Fake implements Uri {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env/.local').readAsStringSync());
  group('AuthenticationRepository', () {
    late AuthenticationRepository authRepository;
    late AuthenticationService authService;
    late UserStorage userStorage;

    setUpAll(() {});

    setUp(() async {
      registerFallbackValue(FakeUri());
      authService = MockAuthService();
      authRepository = AuthenticationRepository(authService: authService);

      when(() => authService.logIn(
              username: any(named: "username"),
              password: any(named: "password")))
          .thenAnswer((_) async => const UserToken(token: "awesomeToken"));
      SharedPreferences.setMockInitialValues({});
      userStorage = await UserStorage.getInstance();
    });
    group('Constructor', () {
      test('Does not required a authentication service', () {
        expect(AuthenticationRepository(), isNotNull);
        expect(authService, isNotNull);
      });
    });
    group('Getters', () {
      test('get status', () async {
        expectLater(
            authRepository.status, emits(AuthenticationStatus.unauthenticated));
      });
    });

    group('Perform login', () {
      test('Login OK', () async {
        await authRepository.logIn(password: "password", username: "username");
        expect(await userStorage.getString("token"), "awesomeToken");
      });
      test('Emits auth status OK', () async {
        expectLater(
            authRepository.status,
            emitsInOrder([
              AuthenticationStatus.unauthenticated,
              AuthenticationStatus.authenticated
            ]));
        await authRepository.logIn(password: "password", username: "username");
      });

      test('Emits auth status unknown on exception', () async {
        when(() => authService.logIn(
            username: any(named: "username"),
            password: any(named: "password"))).thenThrow(ErrorBadRequest());
        expectLater(
            authRepository.status,
            emitsInOrder([
              AuthenticationStatus.unauthenticated,
              AuthenticationStatus.unknown
            ]));
        try {
          await authRepository.logIn(
              password: "password", username: "username");
        } catch (e) {
          expect(e, isA<ErrorBadRequest>());
        }
      });
    });

    group('Other methods', () {
      test('Logout', () async {
        final StreamController authStreamController =
            StreamController<AuthenticationStatus>();
        authStreamController.add(AuthenticationStatus.unknown);
        expectLater(
            authRepository.status,
            emits(
              AuthenticationStatus.unauthenticated,
            ));
        authRepository.logOut();
      });

      test('Dispose', () async {
        expectLater(
            authRepository.status,
            emits(
              AuthenticationStatus.unauthenticated,
            ));
        authRepository.dispose();
      });
    });
  });
}
