import 'package:json_annotation/json_annotation.dart';

part 'year_comparison_point.g.dart';

@JsonSerializable()
class YearComparisonPoint {
  final int month;
  final String label;
  final double income2025;
  final double income2026;
  final int payments2025;
  final int payments2026;

  YearComparisonPoint({
    required this.month,
    required this.label,
    required this.income2025,
    required this.income2026,
    required this.payments2025,
    required this.payments2026,
  });

  factory YearComparisonPoint.fromJson(Map<String, dynamic> json) =>
      _$YearComparisonPointFromJson(json);

  Map<String, dynamic> toJson() => _$YearComparisonPointToJson(this);
}