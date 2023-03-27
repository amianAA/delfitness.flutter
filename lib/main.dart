import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserStorage.init();
  return runApp(DelfitnessApp(
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository()));
}
