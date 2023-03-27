import 'dart:async';
import 'dart:convert';

import 'package:api_repository/api_repository.dart';
import 'package:authentication_repository/src/models/models.dart';
import 'package:user_repository/user_repository.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository with APIRepositoryMixin {
  final _statusController = StreamController<AuthenticationStatus>();
  static final _authEndpoint = String.fromEnvironment("authEndpoint");

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _statusController.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final resp = await httpPost(
        path: _authEndpoint,
        body: {'username': username, 'password': password});
    if (resp.statusCode == 200) {
      UserToken userToken = UserToken.fromJson(json.decode(resp.body));
      UserStorage.setString("accessToken", userToken.accessToken);
      UserStorage.setString("refreshToken", userToken.refreshToken);
      _statusController.add(AuthenticationStatus.authenticated);
    } else {
      _statusController.add(AuthenticationStatus.unknown);
    }
  }

  void logOut() {
    _statusController.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _statusController.close();
  }
}
