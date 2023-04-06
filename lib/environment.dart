import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Environment {
  static String apiUrl = dotenv.get('API_URL');
  static  int apiPort = int.parse(dotenv.get('API_PORT'));
}