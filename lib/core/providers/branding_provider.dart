import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/local_storage_service.dart';

class CustomLogoNotifier extends Notifier<String?> {
  @override
  String? build() {
    final storage = ref.watch(localStorageServiceProvider);
    return storage.getCustomLogo();
  }

  Future<void> setCustomLogo(String logoData) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.saveCustomLogo(logoData);
    state = logoData;
  }

  Future<void> resetToDefault() async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.clearCustomLogo();
    state = null;
  }
}

final customLogoProvider = NotifierProvider<CustomLogoNotifier, String?>(
  CustomLogoNotifier.new,
);
