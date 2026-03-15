import 'package:json_annotation/json_annotation.dart';

part 'income_by_month.g.dart';

@JsonSerializable()
class IncomeByMonth {
  final int month;
  final String label;
  final double totalIncome;
  final int paymentCount;

  IncomeByMonth({
    required this.month,
    required this.label,
    required this.totalIncome,
    required this.paymentCount,
  });

  factory IncomeByMonth.fromJson(Map<String, dynamic> json) =>
      _$IncomeByMonthFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeByMonthToJson(this);
}