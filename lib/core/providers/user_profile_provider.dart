import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../network/api_client.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    return _fetchProfile();
  }

  Future<UserProfile?> _fetchProfile() async {
    try {
      final json = await ApiClient.instance.getCurrentUserInformation();
      if (json != null && json.containsKey('UserId')) {
        return UserProfile.fromJson(json);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchProfile);
  }
}

final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);
