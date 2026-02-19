import 'package:gymify_desktop/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'training.g.dart';

@JsonSerializable()
class Training {
  final int id;
  final int userId;
  User? user;
  final String name;
  String? trainingImage;
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
