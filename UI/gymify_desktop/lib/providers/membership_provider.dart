import 'package:gymify_desktop/models/membership.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class MembershipProvider extends BaseProvider<Membership> {
  MembershipProvider() : super("Membership");

  @override
  Membership fromJson(dynamic data) => Membership.fromJson(data);
}