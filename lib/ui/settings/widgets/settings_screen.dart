import 'package:flutter/material.dart';

// Schermata impostazioni.
// Per ora contiene solo il titolo della sezione.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Palette privata della schermata impostazioni.
  static const _SettingsScreenColors _colors = _SettingsScreenColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.backgroundColor,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF6FAFF),
              Color(0xFFF2F6FC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titolo pagina: stesso stile di "Elenco Linee".
                Text(
                  'Impostazioni',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _colors.titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
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

// Colori specifici della schermata impostazioni.
class _SettingsScreenColors {
  const _SettingsScreenColors();

  final Color backgroundColor = const Color(0xFFF6FAFF);

  final Color titleColor = const Color(0xFF111827);
}