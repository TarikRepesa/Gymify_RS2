// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardReport _$DashboardReportFromJson(Map<String, dynamic> json) =>
    DashboardReport(
      topTrainers: (json['topTrainers'] as List<dynamic>)
          .map((e) => TopTrainerReportItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      bestTrainingAllTime: json['bestTrainingAllTime'] == null
          ? null
          : TopTrainingAllTimeReportItem.fromJson(
              json['bestTrainingAllTime'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$DashboardReportToJson(DashboardReport instance) =>
    <String, dynamic>{
      'topTrainers': instance.topTrainers.map((e) => e.toJson()).toList(),
      'bestTrainingAllTime': instance.bestTrainingAllTime?.toJson(),
    };
