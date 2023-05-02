import 'package:delfitness/common/repositories/authentication/authentication_repository.dart';
import 'package:delfitness/common/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delfitness/ui/views/profile/profile_page.dart';
import 'package:delfitness/ui/views/login/login_page.dart';
import 'package:delfitness/ui/views/splash/splash_page.dart';
import 'package:delfitness/core/authentication/bloc/authentication_bloc.dart';

class DelfitnessApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  const DelfitnessApp({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: DelfitnessAppView(),
      ),
    );
  }
}

class DelfitnessAppView extends StatelessWidget {
  DelfitnessAppView({Key? key}) : super(key: key);
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) =>
          BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.authenticated:
              _navigator.pushAndRemoveUntil<void>(
                ProfilePage.route(),
                (route) => false,
              );
              break;
            case AuthenticationStatus.unauthenticated:
              _navigator.pushAndRemoveUntil<void>(
                LoginPage.route(),
                (route) => false,
              );
              break;
            default:
              break;
          }
        },
        child: child,
      ),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
