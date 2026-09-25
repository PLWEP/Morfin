import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/metadata/lobby_metadata.dart';
import '../../core/metadata/metadata_service.dart';
import '../../core/widgets/lobby/lobby_grid.dart';
import '../../theme/app_colors.dart';

class LobbyScreen extends StatefulWidget {
  final LobbyPageMetadata? initialMetadata;
  final VoidCallback? onAlertTap;

  const LobbyScreen({
    super.key,
    this.initialMetadata,
    this.onAlertTap,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late LobbyPageMetadata _metadata;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _metadata = widget.initialMetadata ?? AppMetadataService.defaultLobby;
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _metadata = AppMetadataService.defaultLobby;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceCard,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _metadata.title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            if (_metadata.subtitle != null)
              Text(
                _metadata.subtitle!,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: _isLoading ? null : _refresh,
          ),
          if (widget.onAlertTap != null)
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, size: 20),
              onPressed: widget.onAlertTap,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: colors.primary,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: LobbyGrid(elements: _metadata.elements),
        ),
      ),
    );
  }
}
