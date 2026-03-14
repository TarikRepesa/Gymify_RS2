import 'package:json_annotation/json_annotation.dart';
import 'package:gymify_mobile/models/user.dart';

part 'training.g.dart';

@JsonSerializable()
class Training {
  final int id;
  final int? userId;
  final User? user;
  final String? name;
  final int? durationMinutes;
  final int? intensityLevel;
  final String? purpose;
  final String? trainingImage;
  final int? maxAmountOfParticipants;
  final int? currentParticipants;
  final int? paricipatedOfAllTime;
  final DateTime? startDate;

  Training({
    required this.id,
    this.userId,
    this.user,
    this.name,
    this.durationMinutes,
    this.intensityLevel,
    this.purpose,
    this.trainingImage,
    this.maxAmountOfParticipants,
    this.currentParticipants,
    this.paricipatedOfAllTime,
    this.startDate,
  });

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingToJson(this);
}