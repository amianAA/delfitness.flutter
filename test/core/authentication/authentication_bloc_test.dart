import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:delfitness/common/repositories/authentication/authentication_repository.dart';
import 'package:delfitness/common/repositories/user/models/user.dart';
import 'package:delfitness/common/repositories/user/user_repository.dart';
import 'package:delfitness/core/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthenticationRepository {
  final _authenticationStreamController =
      StreamController<AuthenticationStatus>();

  @override
  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _authenticationStreamController.stream;
  }
}

class MockUserRepository extends Mock implements UserRepository {}

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
  group(
    "Authentication BLoC",
    () {
      late AuthenticationRepository authRepository;
      late UserRepository userRepository;
      setUp(() {
        authRepository = MockAuthRepository();
        userRepository = MockUserRepository();
      });
      test("initial state of the BLoC is <AuthenticationState.unknown>", () {
        expect(
            AuthenticationBloc(
                    authenticationRepository: authRepository,
                    userRepository: userRepository)
                .state,
            const AuthenticationState.unknown());
      });

      blocTest<AuthenticationBloc, AuthenticationState>(
          "On authentication BLoC emits status <AuthenticationState.authenticated(user)>",
          setUp: () {
            when(() => userRepository.whoIAm())
                .thenAnswer((_) async => mockedUser);
          },
          build: () => AuthenticationBloc(
              authenticationRepository: authRepository,
              userRepository: userRepository),
          act: (bloc) => bloc.add(const AuthenticationStatusChanged(
              AuthenticationStatus.authenticated)),
          expect: () => <AuthenticationState>[
                const AuthenticationState.authenticated(mockedUser),
                const AuthenticationState.unauthenticated(),
              ],
          verify: (_) async {
            verify(() => userRepository.whoIAm()).called(1);
          });
      blocTest<AuthenticationBloc, AuthenticationState>(
          "On default event BLoC emits status <AuthenticationState.unknown()>",
          setUp: () {
            when(() => userRepository.whoIAm())
                .thenAnswer((_) async => mockedUser);
          },
          build: () => AuthenticationBloc(
              authenticationRepository: authRepository,
              userRepository: userRepository),
          act: (bloc) => bloc.add(
              const AuthenticationStatusChanged(AuthenticationStatus.unknown)),
          expect: () => <AuthenticationState>[
                const AuthenticationState.unknown(),
                const AuthenticationState.unauthenticated(),
              ],
          verify: (_) async {
            verifyNever(() => userRepository.whoIAm());
          });
      blocTest<AuthenticationBloc, AuthenticationState>(
          "On logout <AuthenticationState.unauthenticated()>",
          setUp: () {
            when(() => userRepository.whoIAm())
                .thenAnswer((_) async => mockedUser);
          },
          build: () => AuthenticationBloc(
              authenticationRepository: authRepository,
              userRepository: userRepository),
          act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
          expect: () => <AuthenticationState>[
                const AuthenticationState.unauthenticated(),
              ],
          verify: (_) async {
            verify(() => authRepository.logOut()).called(1);
          });
    },
  );
  group(
    "Authentication BLoC events",
    () {
      test("AuthenticationLogoutRequested props is empty", () {
        expect(AuthenticationLogoutRequested().props, []);
      });
      test("AuthenticationStatusChanged props is current 'status'", () {
        expect(
            const AuthenticationStatusChanged(
                    AuthenticationStatus.authenticated)
                .props,
            [AuthenticationStatus.authenticated]);
      });
    },
  );

  group(
    "Authentication BLoC states",
    () {
      test("AuthenticationState.status is unauthenticated", () {
        AuthenticationState authState =
            const AuthenticationState.unauthenticated();

        expect(authState.status, AuthenticationStatus.unauthenticated);
      });
    },
  );
}
