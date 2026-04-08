// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  membershipId: (json['membershipId'] as num).toInt(),
  membership: json['membership'] == null
      ? null
      : Membership.fromJson(json['membership'] as Map<String, dynamic>),
  amount: Payment._toDouble(json['amount']),
  paymentDate: DateTime.parse(json['paymentDate'] as String),
  paymentStatus: json['paymentStatus'] as String?,
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'user': instance.user,
  'membershipId': instance.membershipId,
  'membership': instance.membership,
  'paymentStatus': instance.paymentStatus,
  'amount': instance.amount,
  'paymentDate': instance.paymentDate.toIso8601String(),
};
