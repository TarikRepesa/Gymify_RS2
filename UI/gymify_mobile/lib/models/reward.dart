import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward {
  final int id;
  final String name;
  final String? description;
  final int requiredPoints;
  final bool isActive;

  Reward({
    required this.id,
    required this.name,
    this.description,
    required this.requiredPoints,
    required this.isActive,
  });

  factory Reward.fromJson(Map<String, dynamic> json) =>
      _$RewardFromJson(json);

  Map<String, dynamic> toJson() => _$RewardToJson(this);
}