import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward {
  final int id;
  final String name;
  final String? description;
  final int requiredPoints;
  final String status;
  final DateTime validFrom;
  final DateTime validTo;
  final bool isLockedForEdit;
  final bool canDelete;
  final int redemptionCount;

  Reward({
    required this.id,
    required this.name,
    this.description,
    required this.requiredPoints,
    required this.status,
    required this.validFrom,
    required this.validTo,
    required this.isLockedForEdit,
    required this.canDelete,
    required this.redemptionCount,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  Map<String, dynamic> toJson() => _$RewardToJson(this);
}