// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Membership _$MembershipFromJson(Map<String, dynamic> json) => Membership(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
  yearPrice: (json['yearPrice'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MembershipToJson(Membership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'monthlyPrice': instance.monthlyPrice,
      'yearPrice': instance.yearPrice,
      'createdAt': instance.createdAt.toIso8601String(),
    };
