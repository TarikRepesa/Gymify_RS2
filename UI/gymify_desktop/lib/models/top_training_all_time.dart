import 'package:json_annotation/json_annotation.dart';

part 'top_training_all_time.g.dart';

@JsonSerializable()
class TopTrainingAllTimeReportItem {
  final int trainingId;
  final String name;
  final int participatedOfAllTime;
  final int trainerId;
  final String trainerName;

  TopTrainingAllTimeReportItem({
    required this.trainingId,
    required this.name,
    required this.participatedOfAllTime,
    required this.trainerId,
    required this.trainerName,
  });

  factory TopTrainingAllTimeReportItem.fromJson(Map<String, dynamic> json) =>
      _$TopTrainingAllTimeReportItemFromJson(json);

  Map<String, dynamic> toJson() => _$TopTrainingAllTimeReportItemToJson(this);
}