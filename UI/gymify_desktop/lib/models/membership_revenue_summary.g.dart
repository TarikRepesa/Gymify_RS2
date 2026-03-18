// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_revenue_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipRevenueSummary _$MembershipRevenueSummaryFromJson(
  Map<String, dynamic> json,
) => MembershipRevenueSummary(
  year: (json['year'] as num).toInt(),
  totalIncome: (json['totalIncome'] as num).toInt(),
  totalPayments: (json['totalPayments'] as num).toInt(),
  activeMembers: (json['activeMembers'] as num).toInt(),
  expiredMembers: (json['expiredMembers'] as num).toInt(),
  monthlyIncome: (json['monthlyIncome'] as List<dynamic>)
      .map((e) => IncomeByMonth.fromJson(e as Map<String, dynamic>))
      .toList(),
  packageAnalytics: (json['packageAnalytics'] as List<dynamic>)
      .map(
        (e) => MembershipPackageAnalytics.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$MembershipRevenueSummaryToJson(
  MembershipRevenueSummary instance,
) => <String, dynamic>{
  'year': instance.year,
  'totalIncome': instance.totalIncome,
  'totalPayments': instance.totalPayments,
  'activeMembers': instance.activeMembers,
  'expiredMembers': instance.expiredMembers,
  'monthlyIncome': instance.monthlyIncome.map((e) => e.toJson()).toList(),
  'packageAnalytics': instance.packageAnalytics.map((e) => e.toJson()).toList(),
};
