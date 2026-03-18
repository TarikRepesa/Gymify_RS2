import 'package:json_annotation/json_annotation.dart';

part 'membership_package_analytics.g.dart';

@JsonSerializable()
class MembershipPackageAnalytics {
  final int membershipId;
  final String membershipName;
  final int purchaseCount;
  final int totalIncome;

  MembershipPackageAnalytics({
    required this.membershipId,
    required this.membershipName,
    required this.purchaseCount,
    required this.totalIncome,
  });

  factory MembershipPackageAnalytics.fromJson(Map<String, dynamic> json) =>
      _$MembershipPackageAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipPackageAnalyticsToJson(this);
}