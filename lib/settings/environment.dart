import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Environment {
  static final String apiUrl = dotenv.get('API_URL');
  static final int apiPort = int.parse(dotenv.get('API_PORT'));
  static const String scheme = "http";
}
