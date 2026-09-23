import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'add_server_dialog_header.dart';
import 'add_server_form_fields.dart';

class AddServerDialog extends StatefulWidget {
  final Function(String alias, String url) onServerAdded;

  const AddServerDialog({super.key, required this.onServerAdded});

  static Future<void> show(
    BuildContext context, {
    required Function(String alias, String url) onServerAdded,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) => AddServerDialog(onServerAdded: onServerAdded),
    );
  }

  @override
  State<AddServerDialog> createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<AddServerDialog> {
  final _aliasController =
      TextEditingController(text: 'IFS Cloud Staging EMEA');
  final _urlController =
      TextEditingController(text: 'https://cloud-emea.ifs.com');
  final _formKey = GlobalKey<FormState>();
  String _envType = 'Staging';
  bool _useSsl = true;

  @override
  void dispose() {
    _aliasController.dispose();
    _urlController.dispose();
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.surfaceBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: colors.isDark ? 0.6 : 0.2),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddServerDialogHeader(onClose: () => Navigator.of(context).pop()),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: AddServerFormFields(
                  aliasController: _aliasController,
                  urlController: _urlController,
                  selectedEnvType: _envType,
                  onEnvTypeChanged: (type) => setState(() => _envType = type),
                  useSsl: _useSsl,
                  onSslChanged: (val) => setState(() => _useSsl = val),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow.withValues(alpha: 0.6),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  border: Border(top: BorderSide(color: colors.surfaceBorder)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_rounded, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Save & Connect',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
