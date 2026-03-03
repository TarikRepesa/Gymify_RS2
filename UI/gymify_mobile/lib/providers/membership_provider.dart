import 'package:gymify_mobile/models/membership.dart';
import 'package:gymify_mobile/models/reservation.dart';

import 'base_provider.dart';

class MembershipProvider extends BaseProvider<Membership> {
  MembershipProvider() : super("Membership");

  @override
  Membership fromJson(dynamic data) {
    return Membership.fromJson(data);
  }
}