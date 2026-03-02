import 'package:gymify_mobile/models/training.dart';
import 'package:gymify_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  final int id;
  final int userId;
  final User? user;
  final int trainingId;
  final Training? training;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.userId,
    this.user,
    required this.trainingId,
    this.training,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}