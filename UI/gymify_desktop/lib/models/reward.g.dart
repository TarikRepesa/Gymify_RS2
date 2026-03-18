// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  requiredPoints: (json['requiredPoints'] as num).toInt(),
  status: json['status'] as String,
  validFrom: DateTime.parse(json['validFrom'] as String),
  validTo: DateTime.parse(json['validTo'] as String),
  isLockedForEdit: json['isLockedForEdit'] as bool,
  canDelete: json['canDelete'] as bool,
  redemptionCount: (json['redemptionCount'] as num).toInt(),
);

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'requiredPoints': instance.requiredPoints,
  'status': instance.status,
  'validFrom': instance.validFrom.toIso8601String(),
  'validTo': instance.validTo.toIso8601String(),
  'isLockedForEdit': instance.isLockedForEdit,
  'canDelete': instance.canDelete,
  'redemptionCount': instance.redemptionCount,
};
