import 'package:gymify_mobile/models/notification.dart';
import 'package:http/http.dart' as http;

import 'base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  NotificationProvider() : super("Notification");

  @override
  NotificationModel fromJson(dynamic data) {
    return NotificationModel.fromJson(data);
  }
}