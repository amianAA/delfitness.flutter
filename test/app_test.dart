import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:delfitness/app.dart';
import 'package:delfitness/common/repositories/authentication/authentication_repository.dart';
import 'package:delfitness/common/repositories/user/models/user.dart';
import 'package:delfitness/common/repositories/user/user_repository.dart';
import 'package:delfitness/core/authentication/bloc/authentication_bloc.dart';
import 'package:delfitness/ui/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'core/authentication/authentication_bloc_test.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env/.local').readAsStringSync());

  setUpAll(() {});
  group('DelfitnessApp Tests', () {
    late AuthenticationRepository authRepository;
    late UserRepository userRepository;
    late AuthenticationBloc authBloc;
    const User mockedUser = User(
      id: 1,
      username: "test",
      email: 'test@email.com',
      firstName: 'Pepe',
      lastName: 'García',
    );
    setUp(() {
      authRepository = MockAuthRepository();
      userRepository = MockUserRepository();
      authBloc = MockAuthenticationBloc();
    });

    testWidgets('Delfitness app builds correctly', (tester) async {
      await tester.pumpWidget(DelfitnessApp(
          authenticationRepository: authRepository,
          userRepository: userRepository));
      expect(find.byType(DelfitnessAppView), findsOneWidget);
    });

    testWidgets(
        'Delfitness app navigates to profile page correctly after login',
        (tester) async {
      when(() => authBloc.state).thenReturn(
        const AuthenticationState.authenticated(mockedUser),
      );
      whenListen(
          authBloc,
          Stream.fromIterable([
            const AuthenticationState.unauthenticated(),
            const AuthenticationState.authenticated(mockedUser),
          ]));

      await tester.pumpWidget(
        BlocProvider<AuthenticationBloc>(
          lazy: false,
          create: (_) => authBloc,
          child: MaterialApp(
            home: DelfitnessAppView(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);
    });
  });
}
