import 'dart:async';
import 'dart:convert';

import 'package:delfitness/common/models/token.dart';
import 'package:delfitness/common/services/api_manager.dart';
import 'package:delfitness/common/services/user_preferences.dart';


enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository with APIManagerMixin {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final resp = await httpPost(
        path: const String.fromEnvironment("authEndpoint"),
        body: {'username': username, 'password': password});
    if (resp.statusCode == 200) {
      UserToken userToken = UserToken.fromJson(json.decode(resp.body));
      UserStorage.setString("token", userToken.token);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unknown);
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _controller.close();
  }
}
