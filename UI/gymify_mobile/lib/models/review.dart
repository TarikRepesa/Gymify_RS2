import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final int id;
  final int userId;
  final User? user;
  final String message;
  final int starNumber;

  Review({
    required this.id,
    required this.userId,
    this.user,
    required this.message,
    required this.starNumber,
  });

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}