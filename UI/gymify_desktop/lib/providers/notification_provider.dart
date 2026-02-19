import 'package:flutter/material.dart';
import 'package:gymify_desktop/models/notification.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  NotificationProvider() : super("Notification");

  @override
  NotificationModel fromJson(dynamic data) => NotificationModel.fromJson(data);
}