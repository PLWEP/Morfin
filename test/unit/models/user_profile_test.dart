import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('displayName returns name when present, or userId as fallback', () {
      const p1 = UserProfile(userId: 'ALEX', directoryId: 'corp', name: 'Alex Johnson');
      expect(p1.displayName, 'Alex Johnson');

      const p2 = UserProfile(userId: 'ALEX', directoryId: 'corp', name: '');
      expect(p2.displayName, 'ALEX');
    });

    test('initials generates correct uppercase letters', () {
      const p1 = UserProfile(userId: '1', directoryId: '1', name: 'Alex Johnson');
      expect(p1.initials, 'AJ');

      const p2 = UserProfile(userId: '1', directoryId: '1', name: 'Morgan');
      expect(p2.initials, 'MO');

      const p3 = UserProfile(userId: '1', directoryId: '1', name: 'A');
      expect(p3.initials, 'A');

      const p4 = UserProfile(userId: '', directoryId: '1', name: '');
      expect(p4.initials, 'U');
    });

    test('fromJson and toJson roundtrip properly', () {
      final json = {
        'UserId': 'IFSAPP',
        'DirectoryId': 'GLOBAL',
        'Name': 'IFS Administrator',
        'Email': 'admin@ifs.corp',
        'PersonId': 'PER001',
        'WorkPhone': '+12345678',
        'MobilePhone': '+87654321',
        'JobTitle': 'Systems Lead',
        'FallbackLanguage': 'en',
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.userId, 'IFSAPP');
      expect(profile.directoryId, 'GLOBAL');
      expect(profile.name, 'IFS Administrator');
      expect(profile.email, 'admin@ifs.corp');
      expect(profile.personId, 'PER001');
      expect(profile.workPhone, '+12345678');
      expect(profile.mobilePhone, '+87654321');
      expect(profile.jobTitle, 'Systems Lead');
      expect(profile.fallbackLanguage, 'en');

      final serialized = profile.toJson();
      expect(serialized, json);
    });

    test('fromJson handles alternate IFS field keys', () {
      final json = {
        'UserId': 'TECH1',
        'DirectoryId': 'CORP',
        'Name': 'Technician One',
        'SmtpEmail': 'tech1@ifs.corp',
        'MobileNo': '+999999',
        'Title': 'Field Specialist',
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.email, 'tech1@ifs.corp');
      expect(profile.mobilePhone, '+999999');
      expect(profile.jobTitle, 'Field Specialist');
    });
  });
}
