// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReward _$UserRewardFromJson(Map<String, dynamic> json) => UserReward(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  rewardId: (json['rewardId'] as num).toInt(),
  reward: json['reward'] == null
      ? null
      : Reward.fromJson(json['reward'] as Map<String, dynamic>),
  code: json['code'] as String?,
  redeemedAt: DateTime.parse(json['redeemedAt'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$UserRewardToJson(UserReward instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user,
      'rewardId': instance.rewardId,
      'reward': instance.reward,
      'code': instance.code,
      'redeemedAt': instance.redeemedAt.toIso8601String(),
      'status': instance.status,
    };
