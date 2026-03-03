import 'package:gymify_mobile/models/reward.dart';
import 'base_provider.dart';

class RewardProvider extends BaseProvider<Reward> {
  RewardProvider() : super("Reward");

  @override
  Reward fromJson(dynamic data) {
    return Reward.fromJson(data as Map<String, dynamic>);
  }
}