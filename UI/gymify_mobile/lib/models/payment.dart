import 'package:gymify_mobile/models/membership.dart';
import 'package:gymify_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final int id;
  final int userId;
  User? user;

  final int membershipId;
  final Membership? membership;

  @JsonKey(fromJson: _toDouble)
  final double amount;

  final DateTime paymentDate;

  Payment({
    required this.id,
    required this.userId,
    this.user,
    required this.membershipId,
    this.membership,
    required this.amount,
    required this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  // 🔒 sigurni double parser (ako backend vrati int)
  static double _toDouble(dynamic value) =>
      (value as num).toDouble();

  // 🎯 korisni UI helperi
  String get formattedAmount => "${amount.toStringAsFixed(2)} KM";
}