import 'package:gymify_mobile/models/membership.dart';
import 'package:gymify_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  final int id;
  final int userId;
  final User? user;
  final int membershipId;
  final Membership? membership;
  final DateTime paymentDate;
  final DateTime expirationDate;

  Member({
    required this.id,
    required this.userId,
    this.user,
    required this.membershipId,
    this.membership,
    required this.paymentDate,
    required this.expirationDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) =>
      _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}