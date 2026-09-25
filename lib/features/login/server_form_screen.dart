import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/server_form_field.dart';
import 'models/server_config.dart';

class ServerFormScreen extends StatefulWidget {
  final ServerConfig? initialServer;

  const ServerFormScreen({super.key, this.initialServer});

  @override
  State<ServerFormScreen> createState() => _ServerFormScreenState();
}

class _ServerFormScreenState extends State<ServerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _baseUrlCtrl;
  late final TextEditingController _realmCtrl;
  late final TextEditingController _clientIdCtrl;
  late final TextEditingController _clientSecretCtrl;
  late final TextEditingController _customHostCtrl;
  bool _obscureSecret = true;

  @override
  void initState() {
    super.initState();
    final init = widget.initialServer;
    _nameCtrl = TextEditingController(text: init?.name ?? '');
    _baseUrlCtrl = TextEditingController(text: init?.baseUrl ?? '');
    _realmCtrl = TextEditingController(text: init?.realm ?? '');
    _clientIdCtrl = TextEditingController(text: init?.clientId ?? '');
    _clientSecretCtrl = TextEditingController(text: init?.clientSecret ?? '');
    _customHostCtrl = TextEditingController(text: init?.customHost ?? '');
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _baseUrlCtrl, _realmCtrl, _clientIdCtrl, _clientSecretCtrl, _customHostCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final config = ServerConfig(
      id: widget.initialServer?.id ?? 'srv_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      baseUrl: _baseUrlCtrl.text.trim(),
      realm: _realmCtrl.text.trim(),
      clientId: _clientIdCtrl.text.trim(),
      clientSecret: _clientSecretCtrl.text.trim(),
      customHost: _customHostCtrl.text.trim(),
    );
    Navigator.of(context).pop(config);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isEdit = widget.initialServer != null;

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
          isEdit ? 'Edit Server' : 'Add Server',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: colors.onSurface),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServerFormField(
                  label: 'NAME',
                  controller: _nameCtrl,
                  hint: 'Prod Server',
                  icon: Icons.label_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter server name' : null,
                ),
                const SizedBox(height: 16),
                ServerFormField(
                  label: 'BASE URL',
                  controller: _baseUrlCtrl,
                  hint: 'https://baseurl.com',
                  icon: Icons.link_rounded,
                  isMono: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter base URL';
                    if (!v.startsWith('http://') && !v.startsWith('https://')) {
                      return 'URL must start with http:// or https://';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ServerFormField(
                  label: 'CUSTOM HOST HEADER',
                  controller: _customHostCtrl,
                  hint: 'Optional (e.g. isidemocloud.ifssi.co.id)',
                  icon: Icons.dns_outlined,
                  isMono: true,
                ),
                const SizedBox(height: 16),
                ServerFormField(
                  label: 'REALM',
                  controller: _realmCtrl,
                  hint: 'ifs',
                  icon: Icons.security_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter realm' : null,
                ),
                const SizedBox(height: 16),
                ServerFormField(
                  label: 'CLIENT ID',
                  controller: _clientIdCtrl,
                  hint: 'morfin_mobile_client',
                  icon: Icons.badge_outlined,
                  isMono: true,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter client ID' : null,
                ),
                const SizedBox(height: 16),
                ServerFormField(
                  label: 'CLIENT SECRET',
                  controller: _clientSecretCtrl,
                  hint: 'Optional (e.g. for IFS_connect)',
                  icon: Icons.key_rounded,
                  isMono: true,
                  obscure: _obscureSecret,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureSecret ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 19,
                      color: colors.onSurfaceVariant,
                    ),
                    onPressed: () => setState(() => _obscureSecret = !_obscureSecret),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      isEdit ? 'Save Changes' : 'Save Server',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
