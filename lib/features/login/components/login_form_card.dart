import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../login_contract.dart';
import 'add_server_dialog.dart';

class LoginFormCard extends StatelessWidget {
  final LoginState state;
  final ValueChanged<LoginAction> onAction;

  const LoginFormCard({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.surfaceBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Server Picker Header
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
                onTap: () {
                  AddServerDialog.show(
                    context,
                    onServerAdded: (alias, url) {
                      onAction(LoginAddServerAction(alias, url));
                    },
                  );
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add Server',
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

          // Dropdown Form Field
          DropdownButtonFormField<String>(
            initialValue: state.selectedServer,
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
                value: srv,
                child: Text(
                  srv,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) onAction(LoginSelectServerAction(val));
            },
          ),
          const SizedBox(height: 18),

          // Username Field
          Text(
            'USERNAME',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: state.username,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: colors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Enter username or email',
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
            ),
            onChanged: (val) => onAction(LoginUsernameChangedAction(val)),
          ),
          const SizedBox(height: 18),

          // Password Field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PASSWORD',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Forgot?',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: state.password,
            obscureText: state.isObscurePassword,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: colors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Enter password',
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isObscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 19,
                  color: colors.onSurfaceVariant,
                ),
                onPressed: () => onAction(const LoginTogglePasswordVisibilityAction()),
              ),
            ),
            onChanged: (val) => onAction(LoginPasswordChangedAction(val)),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : () => onAction(const LoginSubmitAction()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.login_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Sign In to IFS Cloud',
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
    );
  }
}
