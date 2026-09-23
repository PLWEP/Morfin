import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/server_card_tile.dart';
import 'models/server_config.dart';
import 'server_form_screen.dart';

class ManageServersScreen extends StatefulWidget {
  final List<ServerConfig> servers;
  final String selectedServerId;
  final ValueChanged<ServerConfig> onSelect;
  final ValueChanged<ServerConfig> onAdd;
  final ValueChanged<ServerConfig> onUpdate;
  final ValueChanged<String> onDelete;

  const ManageServersScreen({
    super.key,
    required this.servers,
    required this.selectedServerId,
    required this.onSelect,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ManageServersScreen> createState() => _ManageServersScreenState();
}

class _ManageServersScreenState extends State<ManageServersScreen> {
  late List<ServerConfig> _servers;
  late String _selectedServerId;

  @override
  void initState() {
    super.initState();
    _servers = List.from(widget.servers);
    _selectedServerId = widget.selectedServerId;
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.of(context).push<ServerConfig>(
      MaterialPageRoute(builder: (_) => const ServerFormScreen()),
    );
    if (result != null) {
      setState(() {
        _servers.insert(0, result);
        _selectedServerId = result.id;
      });
      widget.onAdd(result);
      widget.onSelect(result);
    }
  }

  Future<void> _navigateToEdit(ServerConfig server) async {
    final result = await Navigator.of(context).push<ServerConfig>(
      MaterialPageRoute(builder: (_) => ServerFormScreen(initialServer: server)),
    );
    if (result != null) {
      setState(() {
        final idx = _servers.indexWhere((s) => s.id == result.id);
        if (idx != -1) _servers[idx] = result;
      });
      widget.onUpdate(result);
    }
  }

  void _confirmDelete(ServerConfig server) {
    if (_servers.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one server configuration is required.')),
      );
      return;
    }
    setState(() {
      _servers.removeWhere((s) => s.id == server.id);
      if (_selectedServerId == server.id && _servers.isNotEmpty) {
        _selectedServerId = _servers.first.id;
        widget.onSelect(_servers.first);
      }
    });
    widget.onDelete(server.id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceDeep,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Manage Servers',
          style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: colors.onSurface),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: colors.primary),
            onPressed: _navigateToAdd,
            tooltip: 'Add Server',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CONFIGURED ENDPOINTS (${_servers.length})',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text('Tap to select active', style: GoogleFonts.inter(fontSize: 11, color: colors.outline)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _servers.length,
                itemBuilder: (context, index) {
                  final server = _servers[index];
                  return ServerCardTile(
                    server: server,
                    isSelected: server.id == _selectedServerId,
                    onSelect: () {
                      setState(() => _selectedServerId = server.id);
                      widget.onSelect(server);
                    },
                    onEdit: () => _navigateToEdit(server),
                    onDelete: () => _confirmDelete(server),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _navigateToAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text('Add New Server', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
