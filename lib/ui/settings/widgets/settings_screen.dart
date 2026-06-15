import 'package:flutter/material.dart';

import '../../../domain/models/app_user.dart';
import '../theme/settings_screen_colors.dart';
import '../view_model/settings_view_model.dart';
import 'settings_profile_card.dart';

// Schermata impostazioni.
// Per ora contiene solo l'azione di uscita dall'account
// o dalla modalità ospite.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.user,
    required this.onLogout,
  });

  /// Utente autenticato.
  ///
  /// È null quando JiVaio viene utilizzata
  /// in modalità guest.
  final AppUser? user;

  /// Per un utente autenticato esegue il logout.
  ///
  /// Per un guest ritorna alla schermata di accesso.
  final Future<void> Function() onLogout;

  /// Palette grafica della schermata impostazioni.
  static const SettingsScreenColors _colors = SettingsScreenColors();


  Future<void> _handleLogout() async {
    await onLogout();
  }

  @override
Widget build(BuildContext context) {
  final viewModel = SettingsViewModel(user: user);

  final actionLabel = viewModel.isGuest
      ? 'Accedi o registrati'
      : 'Logout';

  final actionIcon = viewModel.isGuest
      ? Icons.login_rounded
      : Icons.logout_rounded;

  final actionColor = viewModel.isGuest
      ? _colors.primaryAction
      : _colors.dangerAction;

    return Scaffold(
      backgroundColor: _colors.pageBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _colors.gradientStart,
              _colors.gradientEnd,
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
                Text(
  'Impostazioni',
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    color: _colors.titleText,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  ),
),
const SizedBox(height: 18),
SettingsProfileCard(
  title: viewModel.profileTitle,
  subtitle: viewModel.profileSubtitle,
  isGuest: viewModel.isGuest,
  colors: _colors,
),
const SizedBox(height: 20),
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