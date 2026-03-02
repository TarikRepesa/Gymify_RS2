import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final DateTime? dateOfBirth;
  final bool isActive;
  final bool? isAdmin;
  final bool? isRadnik;
  final bool? isTrener;
  final String? userImage;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? phoneNumber;
  final String? aboutMe;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.dateOfBirth,
    required this.isActive,
    this.isAdmin,
    this.isRadnik,
    this.isTrener,
    this.userImage,
    required this.createdAt,
    this.lastLoginAt,
    this.phoneNumber,
    this.aboutMe
  });

  /// fromJson
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Helper (nije obavezno, ali korisno)
  String get fullName => "$firstName $lastName";
}