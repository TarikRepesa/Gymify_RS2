import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymify_desktop/config/api_config.dart';
import 'package:gymify_desktop/helper/http_helper.dart';
import 'package:gymify_desktop/models/dashboard_report.dart';
import 'package:gymify_desktop/models/membership_revenue_summary.dart';
import 'package:gymify_desktop/models/top_training_all_time.dart';
import 'package:gymify_desktop/models/year_comparison_point.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends ChangeNotifier {

  Future<DashboardReport> getDashboard({
    required int year,
    int takeTopTrainers = 5,
  }) async {
    final url = Uri.parse(
      "${ApiConfig.apiBase}/api/Reports/dashboard?year=$year&takeTopTrainers=$takeTopTrainers",
    );

    final response = await http.get(
      url,
      headers: HttpHelper.getHeaders(),
    );

    HttpHelper.checkResponse(response);

    return DashboardReport.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<TopTrainingAllTimeReportItem?> getBestTrainingAllTime() async {
    final url = Uri.parse(
      "${ApiConfig.apiBase}/api/Reports/best-training-alltime",
    );

    final response = await http.get(
      url,
      headers: HttpHelper.getHeaders(),
    );

    HttpHelper.checkResponse(response);

    final body = jsonDecode(response.body);

    if (body == null) return null;

    return TopTrainingAllTimeReportItem.fromJson(body);
  }

  Future<MembershipRevenueSummary> getMembershipRevenueSummary({
    required int year,
  }) async {
    final url = Uri.parse(
      "${ApiConfig.apiBase}/api/Reports/membership-revenue-summary?year=$year",
    );

    final response = await http.get(
      url,
      headers: HttpHelper.getHeaders(),
    );

    HttpHelper.checkResponse(response);

    return MembershipRevenueSummary.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<List<YearComparisonPoint>> getIncomeComparison2025vs2026() async {
    final url = Uri.parse(
      "${ApiConfig.apiBase}/api/Reports/income-comparison-2025-2026",
    );

    final response = await http.get(
      url,
      headers: HttpHelper.getHeaders(),
    );

    HttpHelper.checkResponse(response);

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((e) => YearComparisonPoint.fromJson(e))
        .toList();
  }
}