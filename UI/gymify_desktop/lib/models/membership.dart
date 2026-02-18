import 'package:json_annotation/json_annotation.dart';

part 'membership.g.dart';

@JsonSerializable()
class Membership {
  final int id;
  final String name;
  final double monthlyPrice;
  final double yearPrice;
  final DateTime createdAt;

  Membership({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.yearPrice,
    required this.createdAt,
  });

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);
}
