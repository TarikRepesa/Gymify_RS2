import 'dart:convert';

import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/helper/http_helper.dart';
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

    final response = await http.post(url, headers: HttpHelper.getHeaders());

    HttpHelper.checkResponse(response);

    return true;
  }

  Future<List<Training>> getRecommended({Map<String, dynamic>? filter}) async {
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

    final response = await http.get(uri, headers: HttpHelper.getHeaders());

    HttpHelper.checkResponse(response);

    final data = jsonDecode(response.body);

    return List<Training>.from(data.map((e) => Training.fromJson(e)));
  }

  Future<bool> down(int trainingId) async {
    final url = Uri.parse("${ApiConfig.apiBase}/api/Training/$trainingId/down");

    final response = await http.post(url, headers: HttpHelper.getHeaders());

    HttpHelper.checkResponse(response);

    return true;
  }
}
