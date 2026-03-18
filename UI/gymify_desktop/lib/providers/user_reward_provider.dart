import 'package:gymify_desktop/models/user_reward.dart';
import 'base_provider.dart';

class UserRewardProvider extends BaseProvider<UserReward> {
  UserRewardProvider() : super("UserReward");

  @override
  UserReward fromJson(dynamic data) {
    return UserReward.fromJson(data as Map<String, dynamic>);
  }

  
}