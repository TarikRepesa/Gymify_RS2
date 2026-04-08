import 'package:json_annotation/json_annotation.dart';

part 'payment_intent_start_response.g.dart';

@JsonSerializable()
class PaymentIntentStartResponse {
  final String clientSecret;
  final String intentId;
  final int paymentId;
  final double? amount;
  final String? billingPeriod;

  PaymentIntentStartResponse({
    required this.clientSecret,
    required this.intentId,
    required this.paymentId,
    this.amount,
    this.billingPeriod,
  });

  factory PaymentIntentStartResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentStartResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaymentIntentStartResponseToJson(this);
}