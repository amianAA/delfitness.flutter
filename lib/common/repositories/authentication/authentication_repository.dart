import 'dart:async';
import 'package:delfitness/common/repositories/authentication/models/token.dart';
import 'package:delfitness/common/repositories/authentication/authentication_service.dart';
import 'package:delfitness/common/services/api_manager.dart';
import 'package:delfitness/common/services/user_preferences.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository with APIManagerMixin {
  AuthenticationRepository({AuthenticationService? authService})
      : authenticationService = authService ?? AuthenticationService();
  final _authenticationStreamController =
      StreamController<AuthenticationStatus>();
  late AuthenticationService authenticationService;
  late UserStorage userStorage;

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _authenticationStreamController.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    userStorage = await UserStorage.getInstance();
    try {
      UserToken userToken = await authenticationService.logIn(
          username: username, password: password);
      userStorage.setString("token", userToken.token);
      _authenticationStreamController.add(AuthenticationStatus.authenticated);
    } catch (e) {
      _authenticationStreamController.add(AuthenticationStatus.unknown);
      rethrow;
    }
  }

  void logOut() {
    if (!_authenticationStreamController.isClosed) {
      _authenticationStreamController.add(AuthenticationStatus.unauthenticated);
    }
  }

  void dispose() {
    _authenticationStreamController.close();
  }
}
