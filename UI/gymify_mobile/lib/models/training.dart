import 'package:gymify_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'training.g.dart';

@JsonSerializable()
class Training {
  final int id;
  final int userId;
  final User? user;
  final String name;
  final String? trainingImage;
  final int maxAmountOfParticipants;
  final int currentParticipants;
  final DateTime startDate;

  Training({
    required this.id,
    required this.userId,
    this.user,
    required this.name,
    this.trainingImage,
    required this.maxAmountOfParticipants,
    required this.currentParticipants,
    required this.startDate,
  });

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingToJson(this);
}