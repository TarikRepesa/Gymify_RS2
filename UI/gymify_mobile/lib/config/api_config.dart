import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiBase => dotenv.env['API_BASE_URL_MOBILE'] ?? "";

  static  String imagesUsers = "$apiBase/images/users";
  static  String imagesProperties = "$apiBase/images/training";

  static  Map<String, String> imageFolders = {
    'users': imagesUsers,
    'training': imagesProperties,
  };
}

