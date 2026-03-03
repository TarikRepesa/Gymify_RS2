import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/models/review.dart';
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
      // backend vraća true
      return true;
    }

    throw Exception("Up error: ${response.statusCode} → ${response.body}");
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