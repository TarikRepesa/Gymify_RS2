import 'package:gymify_mobile/models/loyalty_point_history.dart';
import 'base_provider.dart';

class LoyaltyPointHistoryProvider
    extends BaseProvider<LoyaltyPointHistory> {
  LoyaltyPointHistoryProvider()
      : super("LoyaltyPointHistory");

  @override
  LoyaltyPointHistory fromJson(dynamic data) {
    return LoyaltyPointHistory.fromJson(data);
  }
}