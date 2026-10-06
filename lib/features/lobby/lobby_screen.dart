import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/metadata/lobby_metadata.dart';
import '../../core/providers/lobby_provider.dart';
import '../../core/widgets/lobby/lobby_grid.dart';
import '../../theme/app_colors.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  final LobbyPageMetadata? initialMetadata;
  const LobbyScreen({super.key, this.initialMetadata});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _spinController.repeat();
    try {
      await ref.read(lobbyProvider.notifier).refresh();
      if (mounted) {
        final colors = AppColors.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: colors.surfaceCard,
            elevation: 4,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: colors.surfaceBorder.withValues(alpha: 0.9)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: colors.statusSuccess, size: 16),
                const SizedBox(width: 10),
                Text(
                  'Lobby synchronized',
                  style: GoogleFonts.inter(
                    color: colors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        _spinController.stop();
        _spinController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final lobbyAsync = ref.watch(lobbyProvider);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: SafeArea(
        child: lobbyAsync.when(
          loading: () => _buildLoading(colors),
          error: (err, _) => _buildError(colors, err.toString()),
          data: (metadata) => _buildContent(context, metadata),
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

  Widget _buildError(AppPalette colors, String error) => Center(
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

  Widget _buildContent(BuildContext context, LobbyPageMetadata metadata) {
    final colors = AppColors.of(context);

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surfaceCard,
      onRefresh: () => ref.read(lobbyProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metadata.title.isNotEmpty ? metadata.title : 'Lobby',
                        style: GoogleFonts.inter(
                          fontSize: 20, fontWeight: FontWeight.w700,
                          color: colors.onSurface, letterSpacing: -0.5,
                        ),
                      ),
                      if (metadata.subtitle != null && metadata.subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(metadata.subtitle!, style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
                      ],
                    ],
                  ),
                ),
                RotationTransition(
                  turns: _spinController,
                  child: IconButton(
                    icon: Icon(Icons.refresh_rounded, size: 22, color: colors.onSurfaceVariant),
                    onPressed: _handleRefresh,
                    splashRadius: 20,
                    tooltip: 'Refresh Lobby',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
    );
  }
}
