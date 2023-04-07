import 'dart:async';
import 'dart:convert';

import 'package:delfitness/common/models/user.dart';
import 'package:delfitness/common/services/api_manager.dart';
import 'package:delfitness/common/services/user_preferences.dart';

class UserRepository with APIManagerMixin {
  final _userController = StreamController<User>();

  Stream<User> get currentUser async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield User.empty;
    yield* _userController.stream;
  }

  set setCurrentUser(User user) => _userController.add(user);

  Future<User> getUser() async {
    String detailUserPath = '/api/athletes/who-i-am/';
    String token = UserStorage.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token'
    };

    final resp = await httpGet(path: detailUserPath, headers: headers);
    if (resp.statusCode == 200) {
      User user = User.fromJson(json.decode(resp.body));
      return user;
    }
    return User.empty;
  }
}
