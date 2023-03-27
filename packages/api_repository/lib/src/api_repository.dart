import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class APIRepositoryMixin {
  // TODO remove vars and import via .env (or --dart-define)
  String _baseUrl = 'localhost';
  int _basePort = 8000;

  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  // class methods
  Uri _getUriForPath(String path) =>
      Uri(scheme: 'http', host: _baseUrl, path: path, port: _basePort);

  Future httpPost(
          {required String path,
          required Map body,
          Map<String, String> headers = _baseHeaders}) =>
      http.post(_getUriForPath(path), body: json.encode(body), headers: headers)
          .onError((error, stackTrace) => Future(() {
                http.Response response = http.Response(
                    json.encode({
                      "error":
                          "Unable to connect to the server"
                    }),
                    502);
                return response;
              }));

  Future httpGet(
          {required String path,
          Map<String, String> headers = _baseHeaders}) =>
      http.get(_getUriForPath(path), headers: headers)
          .onError((error, stackTrace) => Future(() {
                http.Response response = http.Response(
                    json.encode({
                      "error":
                          "Unable to connect to the server"
                    }),
                    502);
                return response;
              }));
}
