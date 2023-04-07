import 'dart:async';
import 'dart:convert';

import 'package:delfitness/environment.dart';
import 'package:http/http.dart' as http;

class APIManagerMixin {
  final String baseUrl = Environment.apiUrl;
  final int basePort = Environment.apiPort;
  final String scheme = Environment.scheme;

  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  // class methods
  Uri _getUriForPath(String path) =>
      Uri(scheme: scheme, host: baseUrl, path: path, port: basePort);

  Future<http.Response> _errorResponse() => Future(() {
        http.Response response = http.Response(
            json.encode({"error": "Unable to connect to the server"}), 502);
        return response;
      });

  Future httpPost(
      {required String path,
      required Map body,
      Map<String, String> headers = _baseHeaders}) {
    Uri url = _getUriForPath(path);
    return http
        .post(url, body: json.encode(body), headers: headers)
        .onError((error, stackTrace) => _errorResponse());
  }

  Future httpGet(
          {required String path, Map<String, String> headers = _baseHeaders}) =>
      http
          .get(_getUriForPath(path), headers: headers)
          .onError((error, stackTrace) => _errorResponse());

  Future httpPut(
          {required String path, Map<String, String> headers = _baseHeaders}) =>
      http
          .put(_getUriForPath(path), headers: headers)
          .onError((error, stackTrace) => _errorResponse());

  Future httpPatch(
          {required String path, Map<String, String> headers = _baseHeaders}) =>
      http
          .patch(_getUriForPath(path), headers: headers)
          .onError((error, stackTrace) => _errorResponse());

  Future httpDelete(
          {required String path, Map<String, String> headers = _baseHeaders}) =>
      http
          .delete(_getUriForPath(path), headers: headers)
          .onError((error, stackTrace) => _errorResponse());
}
