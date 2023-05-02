import 'package:delfitness/common/repositories/authentication/authentication_service.dart';
import 'package:delfitness/common/repositories/authentication/models/password.dart';
import 'package:delfitness/common/repositories/authentication/models/username.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthenticationService {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('Authentication Models', () {
    group('Password', () {
      test('Test validator - empty password', () {
        const password = Password.dirty();
        expect(password.isValid, false);
        expect(password.validator(""), PasswordValidationError.empty);
      });
    });
    group('Username', () {
      test('Test validator - empty username', () {
        const username = Username.dirty();
        expect(username.isValid, false);
        expect(username.validator(""), UsernameValidationError.empty);
      });
    });
  });
}
