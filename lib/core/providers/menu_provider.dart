import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../metadata/menu_metadata.dart';
import '../services/navigator_service.dart';

class MenuNotifier extends AsyncNotifier<MenuMetadata> {
  @override
  Future<MenuMetadata> build() async {
    return NavigatorService.instance.fetchMenuMetadata();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => NavigatorService.instance.fetchMenuMetadata(forceRefresh: true),
    );
  }

  void clear() {
    NavigatorService.instance.clearCache();
    ref.invalidateSelf();
  }
}

final menuProvider = AsyncNotifierProvider<MenuNotifier, MenuMetadata>(
  MenuNotifier.new,
);
