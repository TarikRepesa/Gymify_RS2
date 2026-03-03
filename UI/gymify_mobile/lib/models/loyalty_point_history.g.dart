// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_point_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyPointHistory _$LoyaltyPointHistoryFromJson(Map<String, dynamic> json) =>
    LoyaltyPointHistory(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String,
      amountPointsParticipation: (json['amountPointsParticipation'] as num)
          .toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LoyaltyPointHistoryToJson(
  LoyaltyPointHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'user': instance.user,
  'status': instance.status,
  'amountPointsParticipation': instance.amountPointsParticipation,
  'createdAt': instance.createdAt.toIso8601String(),
};
