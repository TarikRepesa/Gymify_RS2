import 'package:json_annotation/json_annotation.dart';
import 'package:gymify_mobile/models/user.dart';

part 'loyalty_point.g.dart';

@JsonSerializable()
class LoyaltyPoint {
  final int id;
  final int userId;
  final User? user;
  final int totalPoints;

  LoyaltyPoint({
    required this.id,
    required this.userId,
    this.user,
    required this.totalPoints,
  });

  factory LoyaltyPoint.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyPointFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyPointToJson(this);
}