import 'package:json_annotation/json_annotation.dart';
import 'package:gymify_mobile/models/user.dart';
import 'package:gymify_mobile/models/reward.dart';

part 'user_reward.g.dart';

@JsonSerializable()
class UserReward {
  final int id;

  final int userId;
  final User? user;

  final int rewardId;
  final Reward? reward;

  final String? code;

  final DateTime redeemedAt;

  final bool isUsed;

  UserReward({
    required this.id,
    required this.userId,
    this.user,
    required this.rewardId,
    this.reward,
    this.code,
    required this.redeemedAt,
    required this.isUsed,
  });

  factory UserReward.fromJson(Map<String, dynamic> json) =>
      _$UserRewardFromJson(json);

  Map<String, dynamic> toJson() => _$UserRewardToJson(this);
}