import 'dart:async';
import 'dart:convert';

import 'package:delfitness/common/models/token.dart';
import 'package:delfitness/common/services/api_manager.dart';
import 'package:delfitness/common/services/user_preferences.dart';
import 'package:http/http.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository with APIManagerMixin {
  final _authenticationStreamController =
      StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _authenticationStreamController.stream;
  }

  Future<Response> logIn({
    required String username,
    required String password,
  }) async {
    final resp = await httpPost(
        path: '/auth-token/',
        body: {'username': username, 'password': password});
    if (resp.statusCode == 200) {
      UserToken userToken = UserToken.fromJson(json.decode(resp.body));
      UserStorage.setString("token", userToken.token);
      _authenticationStreamController.add(AuthenticationStatus.authenticated);
    } else {
      _authenticationStreamController.add(AuthenticationStatus.unknown);
    }
    return resp;
  }

  void logOut() {
    _authenticationStreamController.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _authenticationStreamController.close();
  }
}
