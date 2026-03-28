import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiBase => dotenv.env['API_BASE_URL_DESKTOP'] ?? "";
}

