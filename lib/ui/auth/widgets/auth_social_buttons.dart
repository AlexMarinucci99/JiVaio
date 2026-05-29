import 'package:flutter/material.dart';

class AuthSocialButtonsColors {
  const AuthSocialButtonsColors({
    this.foregroundColor = const Color(0xFF191970),
    this.borderColor = const Color(0xFF9CA3AF),
  });

  final Color foregroundColor;
  final Color borderColor;
}

// Riga dei bottoni social della schermata auth.
class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onFacebookPressed,
    this.colors = const AuthSocialButtonsColors(),
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onFacebookPressed;
  final AuthSocialButtonsColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AuthSocialButton(
            label: 'Google',
            iconWidget: const Text(
              'G',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            colors: colors,
            onPressed: onGooglePressed,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _AuthSocialButton(
            label: 'Apple',
            iconWidget: const Icon(Icons.apple_rounded, size: 18),
            colors: colors,
            onPressed: onApplePressed,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _AuthSocialButton(
            label: 'Facebook',
            iconWidget: const Icon(Icons.facebook_rounded, size: 18),
            colors: colors,
            onPressed: onFacebookPressed,
          ),
        ),
      ],
    );
  }
}

class _AuthSocialButton extends StatelessWidget {
  const _AuthSocialButton({
    required this.label,
    required this.iconWidget,
    required this.colors,
    required this.onPressed,
  });

  final String label;
  final Widget iconWidget;
  final AuthSocialButtonsColors colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.foregroundColor,
          side: BorderSide(color: colors.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: colors.foregroundColor),
              child: iconWidget,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
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
}
