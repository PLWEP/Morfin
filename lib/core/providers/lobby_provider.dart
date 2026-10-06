import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../metadata/lobby_metadata.dart';
import '../services/backend_service.dart';

class LobbyNotifier extends AsyncNotifier<LobbyPageMetadata> {
  @override
  Future<LobbyPageMetadata> build() async {
    return _fetchAndHydrate();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAndHydrate());
  }

  Future<LobbyPageMetadata> _fetchAndHydrate() async {
    final meta = await BackendService.instance.fetchLobbyMetadata();
    final elements = List<LobbyElementMetadata>.from(meta.elements);
    final tasks = <Future<void>>[];

    for (int i = 0; i < elements.length; i++) {
      final elem = elements[i];
      if (elem.type == LobbyElementType.counter &&
          elem.targetProjection != null &&
          elem.targetEndpoint != null) {
        final index = i;
        tasks.add(() async {
          try {
            final count = await BackendService.instance.fetchEntityCount(
              projection: elem.targetProjection!,
              entitySet: elem.targetEndpoint!,
              filter: elem.filterConditions,
            );
            elements[index] = elem.copyWith(
              value: count.toString(),
              change: 'Live metrics',
              isPositive: true,
            );
          } catch (_) {
            elements[index] = elem.copyWith(
              value: elem.value ?? '-',
              change: 'Sync error',
              isPositive: false,
            );
          }
        }());
      }
    }

    if (tasks.isNotEmpty) {
      await Future.wait(tasks);
    }

    return LobbyPageMetadata(
      pageId: meta.pageId,
      title: meta.title,
      subtitle: meta.subtitle,
      elements: elements,
    );
  }
}

final lobbyProvider = AsyncNotifierProvider<LobbyNotifier, LobbyPageMetadata>(
  LobbyNotifier.new,
);
