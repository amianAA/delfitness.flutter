import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:delfitness/common/repositories/authentication/authentication_repository.dart';
import 'package:delfitness/common/repositories/authentication/models/errors.dart';
import 'package:delfitness/common/repositories/authentication/models/password.dart';
import 'package:delfitness/common/repositories/authentication/models/username.dart';
import 'package:delfitness/core/login/bloc/login_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

import '../authentication/authentication_bloc_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env/.local').readAsStringSync());

  group("Login BLoC", () {
    late AuthenticationRepository authRepository;
    setUp(() {
      authRepository = MockAuthRepository();
    });
    test("initial state of the BLoC is <LoginState>", () {
      expect(LoginBloc(authenticationRepository: authRepository).state,
          const LoginState());
    });

    blocTest<LoginBloc, LoginState>(
      "On UsernameChanged event, status contains expected username",
      setUp: () {},
      build: () => LoginBloc(authenticationRepository: authRepository),
      act: (bloc) => bloc.add(const LoginUsernameChanged("username")),
      expect: () => <LoginState>[
        const LoginState(username: Username.dirty("username")),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "On PasswordChanged event, status contains expected password",
      setUp: () {},
      build: () => LoginBloc(authenticationRepository: authRepository),
      act: (bloc) => bloc.add(const LoginPasswordChanged("password")),
      expect: () => <LoginState>[
        const LoginState(password: Password.dirty("password")),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "On Submitted event, FormzSubmissionStatus.success is emitted",
      setUp: () {
        when(() => authRepository.logIn(
            username: any(named: "username"),
            password: any(named: "password"))).thenAnswer((_) async {});
      },
      build: () => LoginBloc(authenticationRepository: authRepository),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => <LoginState>[
        const LoginState(status: FormzSubmissionStatus.inProgress),
        const LoginState(
            status: FormzSubmissionStatus.success,
            message: "Bienvenid@ a Delfiness ;)"),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "While Submitted event, if ErrorUnreachable is raised, FormzSubmissionStatus.failure is emitted",
      setUp: () {
        when(() => authRepository.logIn(
            username: any(named: "username"),
            password: any(named: "password"))).thenThrow(ErrorUnreachable);
      },
      build: () => LoginBloc(authenticationRepository: authRepository),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => <LoginState>[
        const LoginState(status: FormzSubmissionStatus.inProgress),
        const LoginState(
            status: FormzSubmissionStatus.failure,
            message:
                "Ha ocurrido un error. Por favor, contacte con el administrador."),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "While Submitted event, if ErrorBadRequest is raised, FormzSubmissionStatus.failure is emitted",
      setUp: () {
        when(() => authRepository.logIn(
            username: any(named: "username"),
            password: any(named: "password"))).thenThrow(ErrorBadRequest);
      },
      build: () => LoginBloc(authenticationRepository: authRepository),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => <LoginState>[
        const LoginState(status: FormzSubmissionStatus.inProgress),
        const LoginState(
            status: FormzSubmissionStatus.failure,
            message: "Las credenciales no son válidas."),
      ],
    );
  });

  group(
    "Login BLoC events",
    () {
      test("LoginSubmitted props is empty", () {
        expect(const LoginSubmitted().props, []);
      });
      test("LoginPasswordChanged props is current 'password'", () {
        expect(const LoginPasswordChanged("password").props, ["password"]);
      });

      test("LoginUsernameChanged props is current 'username'", () {
        expect(const LoginUsernameChanged("username").props, ["username"]);
      });
    },
  );

  group(
    "Login BLoC states",
    () {
      test("LoginState inputs are 'username' and 'password'", () {
        expect(
            const LoginState(
                    username: Username.dirty("username"),
                    password: Password.dirty("password"))
                .inputs,
            [
              const Username.dirty("username"),
              const Password.dirty("password")
            ]);
      });

      test("AuthenticationState.copyWith constructor without status", () {
        LoginState baseLoginState = const LoginState();
        LoginState newLoginState = baseLoginState.copyWith();

        expect(newLoginState.status, FormzSubmissionStatus.initial);
      });
    },
  );
}
