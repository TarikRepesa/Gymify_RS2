import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationModel {
  final int id;
  final int userId;
  final User? user;
  final String title;
  final String content;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    this.user,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}