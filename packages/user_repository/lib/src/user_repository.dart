import 'dart:async';
import 'dart:convert';
import 'package:api_repository/api_repository.dart';
import '../user_repository.dart';


class UserRepository with APIRepositoryMixin {
  final _userController = StreamController<User>();

  Stream<User> get currentUser async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield User.empty;
    yield* _userController.stream;
  }

  set setCurrentUser(User user) => _userController.add(user);

Future<User?> getUser() async {
    String detailUserPath = '/api/v1/users/who-i-am/';
    String accessToken = UserStorage.getString('accessToken');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    final resp = await httpGet(path: detailUserPath, headers: headers);
    if (resp.statusCode == 200) {
      User user = User.fromJson(json.decode(resp.body));
      return user;
    }
    return null;
  }

}
