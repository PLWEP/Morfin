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
      if (elem.targetProjection == null || elem.targetEndpoint == null) continue;

      final index = i;
      tasks.add((() async {
        try {
          if (elem.type == LobbyElementType.indicator) {
            final results = await Future.wait([
              BackendService.instance.fetchRecordCount(
                projection: elem.targetProjection!,
                entitySet: elem.targetEndpoint!,
                filter: elem.filterConditions,
              ),
              BackendService.instance.fetchRecordCount(
                projection: elem.targetProjection!,
                entitySet: elem.targetEndpoint!,
              ),
            ]);
            final count = results[0];
            final total = results[1];
            final pct = total > 0 ? (count / total) * 100.0 : 0.0;
            elements[index] = elem.copyWith(
              value: count.toString(),
              percentage: pct,
              benchmark: '$count of $total',
              change: '$count of $total',
              isPositive: true,
            );
          } else {
            final count = await BackendService.instance.fetchRecordCount(
              projection: elem.targetProjection!,
              entitySet: elem.targetEndpoint!,
              filter: elem.filterConditions,
            );
            elements[index] = elem.copyWith(
              value: count.toString(),
              change: '$count records',
              isPositive: true,
            );
          }
        } catch (_) {
          elements[index] = elem.copyWith(
            value: '-',
            change: 'Sync error',
            percentage: null,
            isPositive: false,
          );
        }
      })());
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
