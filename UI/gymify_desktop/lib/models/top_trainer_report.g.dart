// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_trainer_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopTrainerReportItem _$TopTrainerReportItemFromJson(
  Map<String, dynamic> json,
) => TopTrainerReportItem(
  trainerId: (json['trainerId'] as num).toInt(),
  name: json['name'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$TopTrainerReportItemToJson(
  TopTrainerReportItem instance,
) => <String, dynamic>{
  'trainerId': instance.trainerId,
  'name': instance.name,
  'count': instance.count,
};
