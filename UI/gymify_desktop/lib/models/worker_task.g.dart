// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerTask _$WorkerTaskFromJson(Map<String, dynamic> json) => WorkerTask(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  details: json['details'] as String,
  createdTaskDate: DateTime.parse(json['createdTaskDate'] as String),
  exparationTaskDate: DateTime.parse(json['exparationTaskDate'] as String),
  isFinished: json['isFinished'] as bool,
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$WorkerTaskToJson(WorkerTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'createdTaskDate': instance.createdTaskDate.toIso8601String(),
      'exparationTaskDate': instance.exparationTaskDate.toIso8601String(),
      'isFinished': instance.isFinished,
      'userId': instance.userId,
    };
