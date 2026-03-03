// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  membershipId: (json['membershipId'] as num).toInt(),
  membership: json['membership'] == null
      ? null
      : Membership.fromJson(json['membership'] as Map<String, dynamic>),
  paymentDate: DateTime.parse(json['paymentDate'] as String),
  expirationDate: DateTime.parse(json['expirationDate'] as String),
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'user': instance.user,
  'membershipId': instance.membershipId,
  'membership': instance.membership,
  'paymentDate': instance.paymentDate.toIso8601String(),
  'expirationDate': instance.expirationDate.toIso8601String(),
};
