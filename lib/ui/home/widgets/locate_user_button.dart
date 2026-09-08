import 'package:flutter/material.dart';
import '../theme/home_colors.dart';

/// Pulsante che richiede il centramento della mappa sulla posizione utente.
class LocateUserButton extends StatelessWidget {
  const LocateUserButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    this.colors = const LocateUserButtonColors(),
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final LocateUserButtonColors colors;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Mostra la mia posizione',
      child: Material(
        color: colors.backgroundColor,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: isLoading ? null : onPressed,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: isLoading
                  ? SizedBox.square(
                      dimension: 21,
                      child: CircularProgressIndicator(
                        ///spessore
                        strokeWidth: 2.4,
                        color: colors.iconColor,
                      ),
                    )
                  : Icon(
                      Icons.my_location_rounded,
                      size: 25,
                      color: colors.iconColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
