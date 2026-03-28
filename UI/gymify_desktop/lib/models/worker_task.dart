import 'package:json_annotation/json_annotation.dart';

part 'worker_task.g.dart';

@JsonSerializable()
class WorkerTask {
  final int id;
  final int userId;
  final String name;
  final String details;
  final DateTime createdTaskDate;
  final DateTime expirationTaskDate;
  final bool isFinished;

  WorkerTask({
    required this.id,
    required this.name,
    required this.details,
    required this.createdTaskDate,
    required this.expirationTaskDate,
    required this.isFinished,
    required this.userId,
  });

  factory WorkerTask.fromJson(Map<String, dynamic> json) =>
      _$WorkerTaskFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerTaskToJson(this);
}