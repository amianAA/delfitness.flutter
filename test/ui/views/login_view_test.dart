import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:delfitness/core/login/bloc/login_bloc.dart';
import 'package:delfitness/ui/views/login/login_form.dart';
import 'package:delfitness/ui/views/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env/.local').readAsStringSync());
  late LoginBloc loginBloc;

  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeLoginState());
  });
  group('Login Page', () {
    setUp(() {
      loginBloc = MockLoginBloc();
    });
    testWidgets('renders Login Page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('Shows snackbar on failure', (tester) async {
      when(() => loginBloc.state).thenReturn(
        const LoginState(
            status: FormzSubmissionStatus.failure, message: "Snackbar test"),
      );
      whenListen(
          loginBloc,
          Stream.fromIterable([
            const LoginState(status: FormzSubmissionStatus.initial),
            const LoginState(
                status: FormzSubmissionStatus.failure, message: "Snackbar test")
          ]));

      await tester.pumpWidget(BlocProvider<LoginBloc>(
        lazy: false,
        create: (_) => loginBloc,
        child: const MaterialApp(
          home: LoginForm(),
        ),
      ));
      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.text("Snackbar test"), findsNothing);
      await tester
          .tap(find.byKey(const Key("loginForm_continue_raisedButton")));
      await tester.pumpAndSettle();
      expect(find.text("Snackbar test"), findsOneWidget);
    });

    testWidgets('Username input renders onChanged', (tester) async {
      when(() => loginBloc.state).thenReturn(
        const LoginState(status: FormzSubmissionStatus.initial),
      );

      await tester.pumpWidget(BlocProvider<LoginBloc>(
        lazy: false,
        create: (_) => loginBloc,
        child: const MaterialApp(
          home: LoginForm(),
        ),
      ));
      expect(find.byType(LoginForm), findsOneWidget);
      await tester.enterText(
          find.byKey(const Key("loginForm_usernameInput_textField")), "test");
      await tester.pumpAndSettle();
      verify(() => loginBloc.add(const LoginUsernameChanged("test")));
    });

    testWidgets('Password input renders onChanged', (tester) async {
      when(() => loginBloc.state).thenReturn(
        const LoginState(status: FormzSubmissionStatus.initial),
      );

      await tester.pumpWidget(BlocProvider<LoginBloc>(
        lazy: false,
        create: (_) => loginBloc,
        child: const MaterialApp(
          home: LoginForm(),
        ),
      ));
      expect(find.byType(LoginForm), findsOneWidget);
      await tester.enterText(
          find.byKey(const Key("loginForm_passwordInput_textField")),
          "password");
      await tester.pumpAndSettle();
      verify(() => loginBloc.add(const LoginPasswordChanged("password")));
    });

    test('LoginPage route returns a page Route', () {
      expect(LoginPage.route(), isA<Route>());
    });
  });
}
