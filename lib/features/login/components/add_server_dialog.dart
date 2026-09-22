import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class AddServerDialog extends StatefulWidget {
  final Function(String alias, String url) onServerAdded;

  const AddServerDialog({super.key, required this.onServerAdded});

  static Future<void> show(
    BuildContext context, {
    required Function(String alias, String url) onServerAdded,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddServerDialog(onServerAdded: onServerAdded),
    );
  }

  @override
  State<AddServerDialog> createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<AddServerDialog> {
  final _aliasController = TextEditingController();
  final _urlController = TextEditingController();
  final _realmController = TextEditingController(text: 'PROD-ZONE-01');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _aliasController.dispose();
    _urlController.dispose();
    _realmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onServerAdded(
        _aliasController.text.trim(),
        _urlController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: colors.surfaceBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: colors.isDark ? 0.6 : 0.15),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colors.surfaceBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.dns_rounded,
                      size: 20,
                      color: colors.statusActive,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Server Environment',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                        Text(
                          'Connect to an on-premise or cloud node',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Alias Field
              Text(
                'ENVIRONMENT ALIAS',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _aliasController,
                style: GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
                decoration: const InputDecoration(
                  hintText: 'e.g. IFS Cloud Jakarta Hub',
                  prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter alias' : null,
              ),
              const SizedBox(height: 14),

              // URL Field
              Text(
                'ENDPOINT URL',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _urlController,
                style: GoogleFonts.jetBrainsMono(fontSize: 13, color: colors.onSurface),
                decoration: const InputDecoration(
                  hintText: 'https://ifs.internal.company.com',
                  prefixIcon: Icon(Icons.link_rounded, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter server URL';
                  if (!val.startsWith('http://') && !val.startsWith('https://')) {
                    return 'URL must start with http:// or https://';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Realm / System ID
              Text(
                'SYSTEM REALM / ID',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _realmController,
                style: GoogleFonts.jetBrainsMono(fontSize: 13, color: colors.onSurface),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: colors.surfaceBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_link_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Save Environment',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
