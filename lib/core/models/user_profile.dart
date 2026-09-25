import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String userId;
  final String directoryId;
  final String name;
  final String? email;
  final String? personId;
  final String? workPhone;
  final String? mobilePhone;
  final String? jobTitle;
  final String? fallbackLanguage;

  const UserProfile({
    required this.userId,
    required this.directoryId,
    required this.name,
    this.email,
    this.personId,
    this.workPhone,
    this.mobilePhone,
    this.jobTitle,
    this.fallbackLanguage,
  });

  String get displayName => name.isNotEmpty ? name : userId;

  String get initials {
    if (displayName.isEmpty) return 'U';
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName.substring(0, displayName.length >= 2 ? 2 : 1).toUpperCase();
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['UserId'] as String? ?? '',
        directoryId: json['DirectoryId'] as String? ?? '',
        name: json['Name'] as String? ?? '',
        email: json['Email'] as String? ?? json['SmtpEmail'] as String?,
        personId: json['PersonId'] as String?,
        workPhone: json['WorkPhone'] as String?,
        mobilePhone: json['MobilePhone'] as String? ?? json['MobileNo'] as String?,
        jobTitle: json['JobTitle'] as String? ?? json['Title'] as String?,
        fallbackLanguage: json['FallbackLanguage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'UserId': userId,
        'DirectoryId': directoryId,
        'Name': name,
        'Email': email,
        'PersonId': personId,
        'WorkPhone': workPhone,
        'MobilePhone': mobilePhone,
        'JobTitle': jobTitle,
        'FallbackLanguage': fallbackLanguage,
      };
}
