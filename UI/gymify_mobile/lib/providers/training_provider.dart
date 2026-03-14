import 'dart:convert';

import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/models/training.dart';
import 'package:gymify_mobile/utils/session.dart';
import 'package:http/http.dart' as http;



import 'base_provider.dart';

class TrainingProvider extends BaseProvider<Training> {
  TrainingProvider() : super("Training");

  @override
  Training fromJson(dynamic data) {
    return Training.fromJson(data);
  }

  Future<bool> up(int trainingId) async {
    final url = Uri.parse("${ApiConfig.apiBase}/api/Training/$trainingId/up");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    }

    throw Exception("Up error: ${response.statusCode} → ${response.body}");
  }

  Future<List<Training>> getRecommended({
    Map<String, dynamic>? filter,
  }) async {
    final queryParams = <String, String>{};

    if (filter != null) {
      filter.forEach((key, value) {
        if (value != null) {
          queryParams[key] = value.toString();
        }
      });
    }

    final uri = Uri.parse(
      "${ApiConfig.apiBase}/api/Training/recommended",
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map((e) => Training.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("Recommended response is not a list.");
    }

    throw Exception(
      "Get recommended error: ${response.statusCode} -> ${response.body}",
    );
  }

  Future<bool> down(int trainingId) async {
    final url = Uri.parse("${ApiConfig.apiBase}/api/Training/$trainingId/down");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    }

    throw Exception("Down error: ${response.statusCode} → ${response.body}");
  }
}