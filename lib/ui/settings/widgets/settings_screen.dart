import 'package:flutter/material.dart';

// Schermata impostazioni.
// Per ora contiene solo l'azione di uscita dall'account
// o dalla modalità ospite.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.isGuest,
    required this.onLogout,
  });

  // true = utente ospite
  // false = utente autenticato con Firebase
  final bool isGuest;

  // Per utente registrato: logout Firebase.
  // Per guest: ritorno alla schermata di accesso.
  final Future<void> Function() onLogout;

  // Palette privata della schermata impostazioni.
  static const _SettingsScreenColors _colors = _SettingsScreenColors();

  Future<void> _handleLogout() async {
    await onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final actionLabel = isGuest ? 'Accedi o registrati' : 'Logout';

    final actionIcon = isGuest
        ? Icons.login_rounded
        : Icons.logout_rounded;

    final actionColor = isGuest
        ? _colors.primaryColor
        : _colors.logoutColor;

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
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
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

                const SizedBox(height: 28),

                // Azione principale della schermata.
                TextButton.icon(
                  onPressed: _handleLogout,
                  icon: Icon(
                    actionIcon,
                    size: 24,
                    color: actionColor,
                  ),
                  label: Text(
                    actionLabel,
                    style: TextStyle(
                      color: actionColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 44),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
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

  final Color primaryColor = const Color(0xFF102A6B);

  final Color logoutColor = const Color(0xFFDC2626);
}