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

  final String status;

  UserReward({
    required this.id,
    required this.userId,
    this.user,
    required this.rewardId,
    this.reward,
    this.code,
    required this.redeemedAt,
    required this.status,
  });

  bool get isUsed => status == "Used";

  bool get isExpired => status == "Expired";

  bool get isActive => status == "Active";

  factory UserReward.fromJson(Map<String, dynamic> json) =>
      _$UserRewardFromJson(json);

  Map<String, dynamic> toJson() => _$UserRewardToJson(this);
}