// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_start_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentIntentStartResponse _$PaymentIntentStartResponseFromJson(
  Map<String, dynamic> json,
) => PaymentIntentStartResponse(
  clientSecret: json['clientSecret'] as String,
  intentId: json['intentId'] as String,
  paymentId: (json['paymentId'] as num).toInt(),
  amount: (json['amount'] as num?)?.toDouble(),
  billingPeriod: json['billingPeriod'] as String?,
);

Map<String, dynamic> _$PaymentIntentStartResponseToJson(
  PaymentIntentStartResponse instance,
) => <String, dynamic>{
  'clientSecret': instance.clientSecret,
  'intentId': instance.intentId,
  'paymentId': instance.paymentId,
  'amount': instance.amount,
  'billingPeriod': instance.billingPeriod,
};
