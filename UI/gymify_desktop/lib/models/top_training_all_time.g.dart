// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_training_all_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopTrainingAllTimeReportItem _$TopTrainingAllTimeReportItemFromJson(
  Map<String, dynamic> json,
) => TopTrainingAllTimeReportItem(
  trainingId: (json['trainingId'] as num).toInt(),
  name: json['name'] as String,
  participatedOfAllTime: (json['participatedOfAllTime'] as num).toInt(),
  trainerId: (json['trainerId'] as num).toInt(),
  trainerName: json['trainerName'] as String,
);

Map<String, dynamic> _$TopTrainingAllTimeReportItemToJson(
  TopTrainingAllTimeReportItem instance,
) => <String, dynamic>{
  'trainingId': instance.trainingId,
  'name': instance.name,
  'participatedOfAllTime': instance.participatedOfAllTime,
  'trainerId': instance.trainerId,
  'trainerName': instance.trainerName,
};
