import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../login_contract.dart';
import '../manage_servers_screen.dart';

class ServerEnvironmentSelector extends StatelessWidget {
  final LoginState state;
  final ValueChanged<LoginAction> onAction;

  const ServerEnvironmentSelector({
    super.key,
    required this.state,
    required this.onAction,
  });

  void _openManageServers(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ManageServersScreen(
          servers: state.servers,
          selectedServerId: state.selectedServer.id,
          onSelect: (server) => onAction(LoginSelectServerAction(server)),
          onAdd: (server) => onAction(LoginAddServerAction(server)),
          onUpdate: (server) => onAction(LoginUpdateServerAction(server)),
          onDelete: (id) => onAction(LoginDeleteServerAction(id)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SERVER ENVIRONMENT',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            InkWell(
              onTap: () => _openManageServers(context),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 14,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Manage Server',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey(state.selectedServer.id),
          initialValue: state.selectedServer.id,
          isExpanded: true,
          dropdownColor: colors.surfaceCard,
          icon: Icon(
            Icons.expand_more_rounded,
            color: colors.onSurfaceVariant,
          ),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: colors.onSurface,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.dns_outlined,
              size: 19,
              color: colors.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          items: state.servers.map((srv) {
            return DropdownMenuItem<String>(
              value: srv.id,
              child: Text(
                srv.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (selectedId) {
            if (selectedId != null) {
              final chosen = state.servers.firstWhere(
                (s) => s.id == selectedId,
                orElse: () => state.selectedServer,
              );
              onAction(LoginSelectServerAction(chosen));
            }
          },
        ),
      ],
    );
  }
}
