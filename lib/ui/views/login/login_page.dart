import 'package:delfitness/common/repositories/authentication/authentication_repository.dart';
import 'package:delfitness/common/repositories/authentication/authentication_service.dart';
import 'package:delfitness/core/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          AuthenticationRepository(authService: AuthenticationService()),
      child: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          );
        },
        child: const LoginForm(),
      ),
    );
  }
}
