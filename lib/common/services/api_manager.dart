import 'package:delfitness/settings/environment.dart';

class APIManagerMixin {
  final String baseUrl = Environment.apiUrl;
  final int basePort = Environment.apiPort;
  final String scheme = Environment.scheme;

  // class methods
  Uri getUriForPath(String path) =>
      Uri(scheme: scheme, host: baseUrl, path: path, port: basePort);
}
