import 'dart:async';
import 'dart:convert';

import 'package:delfitness/common/repositories/authentication/models/errors.dart';
import 'package:delfitness/common/repositories/authentication/models/token.dart';
import 'package:delfitness/common/services/api_manager.dart';
import 'package:http/http.dart' as http;

class AuthenticationService with APIManagerMixin {
  AuthenticationService({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<UserToken> logIn({
    required String username,
    required String password,
  }) async {
    final response = await _httpClient.post(getUriForPath('/auth-token/'),
        body: json.encode({'username': username, 'password': password}),
        headers: _baseHeaders);
    if (response.statusCode == 200) {
      return UserToken.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw ErrorBadRequest;
    } else {
      throw ErrorUnreachable;
    }
  }
}
