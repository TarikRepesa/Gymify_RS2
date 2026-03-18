import 'package:gymify_desktop/models/income_by_month.dart';
import 'package:gymify_desktop/models/membership_package_analytics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'membership_revenue_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class MembershipRevenueSummary {
  final int year;
  final int totalIncome;
  final int totalPayments;
  final int activeMembers;
  final int expiredMembers;
  final List<IncomeByMonth> monthlyIncome;
  final List<MembershipPackageAnalytics> packageAnalytics;

  MembershipRevenueSummary({
    required this.year,
    required this.totalIncome,
    required this.totalPayments,
    required this.activeMembers,
    required this.expiredMembers,
    required this.monthlyIncome,
    required this.packageAnalytics,
  });

  factory MembershipRevenueSummary.fromJson(Map<String, dynamic> json) =>
      _$MembershipRevenueSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipRevenueSummaryToJson(this);
}