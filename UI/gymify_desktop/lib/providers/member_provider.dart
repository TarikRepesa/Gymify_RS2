
import 'package:gymify_desktop/models/member.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class MemberProvider extends BaseProvider<Member> {
  MemberProvider() : super("Member");

  @override
  Member fromJson(dynamic data) => Member.fromJson(data);
}