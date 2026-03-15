import 'package:gymify_desktop/utils/session.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static void checkResponse(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception("Neautorizovan pristup");
    }

    if (response.statusCode == 403) {
      throw Exception("Zabranjen pristup");
    }

    if (response.statusCode < 200 || response.statusCode > 299) {
      print("API ERROR ${response.statusCode}: ${response.body}");
      throw Exception("Došlo je do greške prilikom komunikacije sa serverom.");
    }
  }

  static Map<String, String> getHeaders({bool withToken = true}) {
  final headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  if (withToken && Session.token != null) {
    headers["Authorization"] = "Bearer ${Session.token}";
  }

  return headers;
}
}