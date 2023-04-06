import 'package:delfitness/common/repositories/authentication_repository.dart';
import 'package:delfitness/common/repositories/user_repository.dart';
import 'package:delfitness/common/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserStorage.init();
  await dotenv.load(fileName: '.env/.local');

  return runApp(DelfitnessApp(
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository()));
}
