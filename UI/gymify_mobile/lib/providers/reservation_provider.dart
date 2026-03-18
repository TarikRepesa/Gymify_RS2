import 'dart:convert';
import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/helper/http_helper.dart';
import 'package:gymify_mobile/models/reservation.dart';
import 'package:http/http.dart' as http;

import 'base_provider.dart';

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

  @override
  Reservation fromJson(dynamic data) {
    return Reservation.fromJson(data);
  }

  Future<bool> exists(dynamic request) async {
    final userId = request["userId"];
    final trainingId = request["trainingId"];

    final url = Uri.parse(
      "${ApiConfig.apiBase}/api/Reservation/exists",
    ).replace(
      queryParameters: {
        "userId": userId.toString(),
        "trainingId": trainingId.toString(),
      },
    );

    final response = await http.get(
      url,
      headers: HttpHelper.getHeaders(),
    );

    HttpHelper.checkResponse(response);

    return jsonDecode(response.body) == true;
  }
}