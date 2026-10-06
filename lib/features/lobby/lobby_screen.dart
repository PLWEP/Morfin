import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/metadata/lobby_metadata.dart';
import '../../core/providers/lobby_provider.dart';
import '../../core/widgets/lobby/lobby_grid.dart';
import '../../theme/app_colors.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  final LobbyPageMetadata? initialMetadata;

  const LobbyScreen({
    super.key,
    this.initialMetadata,
  });

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.sync_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Plant KPIs synchronized',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
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
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Syncing Plant KPIs & Telemetry...',
              style: TextStyle(color: colors.outline, fontSize: 13),
            ),
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
              Text(
                'Failed to sync Plant Lobby',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                error,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(color: colors.outline, fontSize: 12),
              ),
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metadata.title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: colors.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        metadata.subtitle ?? 'Live Plant Telemetry & KPIs',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Live Cloud Indicator Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.statusSuccess.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.statusSuccess.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.statusSuccess,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.statusSuccess.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'LIVE',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: colors.statusSuccess,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Sync Action Button with Rotation Animation
                RotationTransition(
                  turns: _spinController,
                  child: Material(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: _handleRefresh,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.7)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.refresh_rounded, size: 18, color: colors.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Operational Telemetry Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceCard.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.sensors_rounded, size: 14, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'IFS Cloud Telemetry Connected',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${metadata.elements.length} KPIs active',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Main Grid Layout
            LobbyGrid(elements: metadata.elements),
          ],
        ),
      ),
    );
  }
}
