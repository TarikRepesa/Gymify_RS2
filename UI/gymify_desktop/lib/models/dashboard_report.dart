import 'package:gymify_desktop/models/top_trainer_report.dart';
import 'package:gymify_desktop/models/top_training_all_time.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_report.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardReport {
  final List<TopTrainerReportItem> topTrainers;
  final TopTrainingAllTimeReportItem? bestTrainingAllTime;

  DashboardReport({
    required this.topTrainers,
    this.bestTrainingAllTime,
  });

  factory DashboardReport.fromJson(Map<String, dynamic> json) =>
      _$DashboardReportFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardReportToJson(this);
}