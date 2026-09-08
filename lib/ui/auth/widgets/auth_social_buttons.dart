import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

/// Mostra i pulsanti per l'accesso tramite provider social.
class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onFacebookPressed,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onFacebookPressed;

  Widget _buildButton({
    required String label,
    required Widget iconWidget,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AuthColors.socialButtonForegroundColor,
          side: const BorderSide(color: AuthColors.socialButtonBorderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            label: 'Google',
            iconWidget: const Text(
              'G',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onPressed: onGooglePressed,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildButton(
            label: 'Apple',
            iconWidget: const Icon(Icons.apple_rounded, size: 18),
            onPressed: onApplePressed,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildButton(
            label: 'Facebook',
            iconWidget: const Icon(Icons.facebook_rounded, size: 18),
            onPressed: onFacebookPressed,
          ),
        ),
      ],
    );
  }
}
