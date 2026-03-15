// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  trainingId: (json['trainingId'] as num).toInt(),
  training: json['training'] == null
      ? null
      : Training.fromJson(json['training'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: json['status'] as String,
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancelReason: json['cancelReason'] as String?,
);

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user,
      'trainingId': instance.trainingId,
      'training': instance.training,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'cancelReason': instance.cancelReason,
    };
