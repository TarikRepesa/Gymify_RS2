// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  name: json['name'] as String?,
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  intensityLevel: (json['intensityLevel'] as num?)?.toInt(),
  purpose: json['purpose'] as String?,
  trainingImage: json['trainingImage'] as String?,
  maxAmountOfParticipants: (json['maxAmountOfParticipants'] as num?)?.toInt(),
  currentParticipants: (json['currentParticipants'] as num?)?.toInt(),
  participatedOfAllTime: (json['participatedOfAllTime'] as num?)?.toInt(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
);

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'user': instance.user,
  'name': instance.name,
  'durationMinutes': instance.durationMinutes,
  'intensityLevel': instance.intensityLevel,
  'purpose': instance.purpose,
  'trainingImage': instance.trainingImage,
  'maxAmountOfParticipants': instance.maxAmountOfParticipants,
  'currentParticipants': instance.currentParticipants,
  'participatedOfAllTime': instance.participatedOfAllTime,
  'startDate': instance.startDate?.toIso8601String(),
};
