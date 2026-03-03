import 'package:json_annotation/json_annotation.dart';
import 'package:gymify_mobile/models/user.dart';

part 'loyalty_point_history.g.dart';

@JsonSerializable()
class LoyaltyPointHistory {
  final int id;
  final int userId;
  final User? user;
  final String status;
  final int amountPointsParticipation;
  final DateTime createdAt;

  LoyaltyPointHistory({
    required this.id,
    required this.userId,
    this.user,
    required this.status,
    required this.amountPointsParticipation,
    required this.createdAt,
  });

  factory LoyaltyPointHistory.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyPointHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyPointHistoryToJson(this);
}