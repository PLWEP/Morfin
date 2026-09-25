import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/activity_log_service.dart';
import '../../../theme/app_colors.dart';
import 'activity_log_item_tile.dart';

class ActivityLogsSheet extends StatefulWidget {
  const ActivityLogsSheet({super.key});

  @override
  State<ActivityLogsSheet> createState() => _ActivityLogsSheetState();
}

class _ActivityLogsSheetState extends State<ActivityLogsSheet> {
  late List<ActivityLogEntry> _logs;

  @override
  void initState() {
    super.initState();
    _logs = ActivityLogService.instance.logs.reversed.toList();
  }

  void _clearLogs() {
    ActivityLogService.instance.clear();
    setState(() => _logs = []);
  }

  void _copyToClipboard() {
    final text = ActivityLogService.instance.exportAsText();
    Clipboard.setData(ClipboardData(text: text));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Activity logs copied to clipboard (${_logs.length} entries)',
          style: GoogleFonts.inter(fontSize: 13),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.assignment_rounded, size: 20, color: colors.statusActive),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Activity Diagnostics',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: colors.onSurface),
                      ),
                      Text(
                        '${_logs.length} recorded events • Ring buffer',
                        style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.surfaceBorder),
          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Text(
                      'No activity records captured yet.',
                      style: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _logs.length,
                    separatorBuilder: (_, _) => Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.4)),
                    itemBuilder: (context, i) => ActivityLogItemTile(entry: _logs[i]),
                  ),
          ),
          Divider(height: 1, color: colors.surfaceBorder),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _logs.isEmpty ? null : _clearLogs,
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                  label: const Text('Clear'),
                  style: OutlinedButton.styleFrom(foregroundColor: colors.statusCritical),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _logs.isEmpty ? null : _copyToClipboard,
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy to Clipboard'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
