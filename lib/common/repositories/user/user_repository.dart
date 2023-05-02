import 'dart:async';

import 'package:delfitness/common/repositories/user/models/user.dart';
import 'package:delfitness/common/repositories/user/user_service.dart';
import 'package:delfitness/common/services/api_manager.dart';

class UserRepository with APIManagerMixin {
  UserRepository({UserService? userService})
      : _userService = userService ?? UserService();

  final _userController = StreamController<User>();
  late final UserService _userService;

  Stream<User> get currentUser async* {
    yield* _userController.stream;
  }

  Future<User> whoIAm() async {
    User user = await _userService.whoIAm();
    _userController.add(user);
    return user;
  }
}
