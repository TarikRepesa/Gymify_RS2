import 'package:gymify_desktop/models/training.dart';
import 'package:gymify_desktop/models/worker_task.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class WorkerTaskProvider extends BaseProvider<WorkerTask> {
  WorkerTaskProvider() : super("WorkerTask");

  @override
  WorkerTask fromJson(dynamic data) => WorkerTask.fromJson(data);
}