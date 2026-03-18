// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_package_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipPackageAnalytics _$MembershipPackageAnalyticsFromJson(
  Map<String, dynamic> json,
) => MembershipPackageAnalytics(
  membershipId: (json['membershipId'] as num).toInt(),
  membershipName: json['membershipName'] as String,
  purchaseCount: (json['purchaseCount'] as num).toInt(),
  totalIncome: (json['totalIncome'] as num).toInt(),
);

Map<String, dynamic> _$MembershipPackageAnalyticsToJson(
  MembershipPackageAnalytics instance,
) => <String, dynamic>{
  'membershipId': instance.membershipId,
  'membershipName': instance.membershipName,
  'purchaseCount': instance.purchaseCount,
  'totalIncome': instance.totalIncome,
};
