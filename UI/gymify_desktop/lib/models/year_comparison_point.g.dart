// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_comparison_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearComparisonPoint _$YearComparisonPointFromJson(Map<String, dynamic> json) =>
    YearComparisonPoint(
      month: (json['month'] as num).toInt(),
      label: json['label'] as String,
      income2025: (json['income2025'] as num).toDouble(),
      income2026: (json['income2026'] as num).toDouble(),
      payments2025: (json['payments2025'] as num).toInt(),
      payments2026: (json['payments2026'] as num).toInt(),
    );

Map<String, dynamic> _$YearComparisonPointToJson(
  YearComparisonPoint instance,
) => <String, dynamic>{
  'month': instance.month,
  'label': instance.label,
  'income2025': instance.income2025,
  'income2026': instance.income2026,
  'payments2025': instance.payments2025,
  'payments2026': instance.payments2026,
};
