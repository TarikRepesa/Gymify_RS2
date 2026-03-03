import 'dart:convert';

import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/models/loyalty_point.dart';
import 'package:gymify_mobile/utils/session.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class LoyaltyPointProvider extends BaseProvider<LoyaltyPoint> {
  LoyaltyPointProvider() : super("LoyaltyPoint");

  @override
  LoyaltyPoint fromJson(dynamic data) {
    return LoyaltyPoint.fromJson(data);
  }

  Future<LoyaltyPoint> addPoints(dynamic request) async {
    final url = Uri.parse("${ApiConfig.apiBase}/api/LoyaltyPoint/add");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      },
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      return LoyaltyPoint.fromJson(jsonDecode(response.body));
    }
    throw Exception("Greška (${response.statusCode}): ${response.body}");
  }

  Future<LoyaltyPoint> subtractPoints(dynamic request) async {
    final url = Uri.parse("${ApiConfig.apiBase}/api/LoyaltyPoint/subtract");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      },
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      return LoyaltyPoint.fromJson(jsonDecode(response.body));
    }
    throw Exception("Greška (${response.statusCode}): ${response.body}");
  }
}