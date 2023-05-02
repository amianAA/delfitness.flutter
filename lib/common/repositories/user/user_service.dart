import 'dart:async';

import 'package:delfitness/common/repositories/user/models/user.dart';
import 'package:delfitness/common/services/api_manager.dart';
import 'package:delfitness/common/services/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserService with APIManagerMixin {
  UserService({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  late UserStorage userStorage;

  Future<User> whoIAm() async {
    userStorage = await UserStorage.getInstance();
    String token = await userStorage.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token'
    };

    final response = await _httpClient
        .get(getUriForPath('/api/athletes/who-i-am/'), headers: headers);
    // TODO remove mocked data and uncomment below code
    if (response.statusCode != 400) {
      return const User(
        id: 1,
        username: "test",
        email: 'test@email.com',
        firstName: 'Pepe',
        lastName: 'García',
      );
    }
    // if (response.statusCode == 200) {
    //   User user = User.fromJson(json.decode(response.body));
    //   return user;
    // }
    return User.empty;
  }
}
