import 'package:json_annotation/json_annotation.dart';

part 'top_trainer_report.g.dart';

@JsonSerializable()
class TopTrainerReportItem {
  final int trainerId;
  final String name;
  final int count;

  TopTrainerReportItem({
    required this.trainerId,
    required this.name,
    required this.count,
  });

  factory TopTrainerReportItem.fromJson(Map<String, dynamic> json) =>
      _$TopTrainerReportItemFromJson(json);

  Map<String, dynamic> toJson() => _$TopTrainerReportItemToJson(this);
}