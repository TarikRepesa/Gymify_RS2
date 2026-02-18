import 'package:gymify_desktop/models/training.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class TrainingProvider extends BaseProvider<Training> {
  TrainingProvider() : super("Training");

  @override
  Training fromJson(dynamic data) => Training.fromJson(data);
}