import 'package:gymify_mobile/models/review.dart';
import 'package:gymify_mobile/models/training.dart';


import 'base_provider.dart';

class TrainingProvider extends BaseProvider<Training> {
  TrainingProvider() : super("Training");

  @override
  Training fromJson(dynamic data) {
    return Training.fromJson(data);
  }
}