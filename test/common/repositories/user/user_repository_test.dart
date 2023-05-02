import 'dart:io';

import 'package:delfitness/common/repositories/user/models/user.dart';
import 'package:delfitness/common/repositories/user/user_repository.dart';
import 'package:delfitness/common/repositories/user/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements UserService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env/.local').readAsStringSync());
  const User mockedUser = User(
    id: 1,
    username: "test",
    email: 'test@email.com',
    firstName: 'Pepe',
    lastName: 'García',
  );
  group('UserRepository', () {
    late UserRepository userRepository;
    late UserService userService;

    setUp(() async {
      userService = MockAuthService();
      userRepository = UserRepository(userService: userService);

      when(() => userService.whoIAm()).thenAnswer((_) async => mockedUser);
    });
    group('Constructor', () {
      test('Does not required a user service', () {
        expect(UserRepository(), isNotNull);
        expect(userService, isNotNull);
      });
    });
    group('Getters', () {
      test('get current user', () async {
        await userRepository.whoIAm();
        expectLater(userRepository.currentUser, emits(mockedUser));
      });
    });

    group('Methods', () {
      test('get current user', () async {
        User currentUser = await userRepository.whoIAm();
        expect(currentUser, mockedUser);
      });
    });
  });
}
