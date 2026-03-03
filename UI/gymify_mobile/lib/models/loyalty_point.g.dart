// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyPoint _$LoyaltyPointFromJson(Map<String, dynamic> json) => LoyaltyPoint(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  totalPoints: (json['totalPoints'] as num).toInt(),
);

Map<String, dynamic> _$LoyaltyPointToJson(LoyaltyPoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user,
      'totalPoints': instance.totalPoints,
    };
