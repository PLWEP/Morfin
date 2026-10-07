import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/metadata/lobby_metadata.dart';
import '../../core/providers/lobby_provider.dart';
import '../../core/widgets/lobby/lobby_grid.dart';
import '../../theme/app_colors.dart';

class LobbyScreen extends ConsumerWidget {
  final LobbyPageMetadata? initialMetadata;
  const LobbyScreen({super.key, this.initialMetadata});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final lobbyAsync = ref.watch(lobbyProvider);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: SafeArea(
        child: lobbyAsync.when(
          loading: () => _buildLoading(colors),
          error: (err, _) => _buildError(ref, colors, err.toString()),
          data: (metadata) => _buildContent(context, ref, metadata, colors),
        ),
      ),
    );
  }

  Widget _buildLoading(AppPalette colors) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.5, color: colors.primary)),
        const SizedBox(height: 16),
        Text('Syncing Lobby...', style: TextStyle(color: colors.outline, fontSize: 13)),
      ],
    ),
  );

  Widget _buildError(WidgetRef ref, AppPalette colors, String error) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 44, color: colors.statusCritical),
          const SizedBox(height: 12),
          Text('Failed to sync Lobby', style: TextStyle(color: colors.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(error, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: colors.outline, fontSize: 12)),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () => ref.read(lobbyProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry Connection'),
          ),
        ],
      ),
    ),
  );

  Widget _buildContent(BuildContext context, WidgetRef ref, LobbyPageMetadata metadata, AppPalette colors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          color: colors.primary,
          backgroundColor: colors.surfaceCard,
          onRefresh: () => ref.read(lobbyProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Container(
                color: Colors.transparent, // Ensures empty space at bottom is hit-testable for pull-to-refresh
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (metadata.elements.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.dashboard_outlined, size: 40, color: colors.outline),
                              const SizedBox(height: 12),
                              Text('No lobby widgets configured', style: TextStyle(color: colors.outline, fontSize: 13)),
                            ],
                          ),
                        ),
                      )
                    else
                      LobbyGrid(elements: metadata.elements),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
