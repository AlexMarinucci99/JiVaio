import 'package:flutter/material.dart';

//StatelessWidget perché riceve dall’esterno lo stato di caricamento e la callback. Non conserva internamente stato mutevole.

class LocateUserButtonColors {
  const LocateUserButtonColors({
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF17226B),
    this.progressColor = const Color(0xFF17226B),
    this.shadowColor = const Color(0x26000000),
  });

  final Color backgroundColor;
  final Color iconColor;
  final Color progressColor;
  final Color shadowColor;
}

// Widget riutilizzabile: gestisce soltanto il rendering del pulsante.
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
        elevation: 5,
        shadowColor: colors.shadowColor,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: isLoading ? null : onPressed,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: colors.progressColor,
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
