import 'package:gymify_mobile/models/member.dart';

import 'base_provider.dart';

class MemberProvider extends BaseProvider<Member> {
  MemberProvider() : super("Member");

  @override
  Member fromJson(dynamic data) {
    return Member.fromJson(data);
  }
}