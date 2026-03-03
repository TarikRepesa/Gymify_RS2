import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymify_desktop/config/api_config.dart';
import 'package:gymify_desktop/models/dashboard_report.dart';
import 'package:gymify_desktop/models/top_training_all_time.dart';
import 'package:gymify_desktop/utils/session.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends ChangeNotifier{
  Future<DashboardReport> getDashboard({required int year, int takeTopTrainers = 5}) async {
    final url = Uri.parse(
      "${ApiConfig.apiBase}/api/Reports/dashboard?year=$year&takeTopTrainers=$takeTopTrainers",
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      },
    );

    if (response.statusCode == 200) {
      return DashboardReport.fromJson(jsonDecode(response.body));
    }

    throw Exception("Greška (${response.statusCode}): ${response.body}");
  }

  Future<TopTrainingAllTimeReportItem?> getBestTrainingAllTime() async {
    final url = Uri.parse("${ApiConfig.apiBase}/api/Reports/best-training-alltime");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body == null) return null;
      return TopTrainingAllTimeReportItem.fromJson(body);
    }

    throw Exception("Greška (${response.statusCode}): ${response.body}");
  }
}