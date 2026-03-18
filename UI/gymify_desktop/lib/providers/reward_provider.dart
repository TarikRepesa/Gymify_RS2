import 'package:gymify_desktop/models/reward.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class RewardProvider extends BaseProvider<Reward> {
  RewardProvider() : super("Reward");

  @override
  Reward fromJson(dynamic data) => Reward.fromJson(data);
}