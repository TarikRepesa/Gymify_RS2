// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_by_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeByMonth _$IncomeByMonthFromJson(Map<String, dynamic> json) =>
    IncomeByMonth(
      month: (json['month'] as num).toInt(),
      label: json['label'] as String,
      totalIncome: (json['totalIncome'] as num).toDouble(),
      paymentCount: (json['paymentCount'] as num).toInt(),
    );

Map<String, dynamic> _$IncomeByMonthToJson(IncomeByMonth instance) =>
    <String, dynamic>{
      'month': instance.month,
      'label': instance.label,
      'totalIncome': instance.totalIncome,
      'paymentCount': instance.paymentCount,
    };
