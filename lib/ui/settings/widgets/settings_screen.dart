import 'package:flutter/material.dart';

import '../../../domain/models/app_user.dart';
import '../theme/settings_screen_colors.dart';
import '../view_model/settings_view_model.dart';
import 'settings_profile_card.dart';
import 'settings_section.dart';
import 'settings_tile.dart';

/// Schermata principale delle impostazioni di JiVaio.
///
/// Riceve l'utente autenticato, oppure null in modalità guest,
/// e mostra le voci disponibili per il relativo profilo.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.user, required this.onLogout});

  /// Utente autenticato.
  ///
  /// È null quando JiVaio viene utilizzata in modalità guest.
  final AppUser? user;

  /// Per un utente autenticato esegue il logout.
  ///
  /// Per un guest ritorna alla schermata di accesso.
  final Future<void> Function() onLogout;

  static const SettingsScreenColors _colors = SettingsScreenColors();

  Future<void> _handleLogout() async {
    await onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = SettingsViewModel(user: user);

    return Scaffold(
      backgroundColor: _colors.pageBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_colors.gradientStart, _colors.gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
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
              const SizedBox(height: 24),
              _buildAccountSection(viewModel),
              const SizedBox(height: 24),
              _buildNotificationsSection(),
              const SizedBox(height: 24),
              _buildPrivacyAndSupportSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(SettingsViewModel viewModel) {
    if (viewModel.isGuest) {
      return SettingsSection(
        title: 'Account',
        colors: _colors,
        children: [
          SettingsTile(
            icon: Icons.login_rounded,
            title: 'Accedi o registrati',
            subtitle: 'Salva le preferenze e personalizza JiVaio',
            iconColor: _colors.primaryAction,
            colors: _colors,
            onTap: () async {
              await _handleLogout();
            },
          ),
        ],
      );
    }

    return SettingsSection(
      title: 'Account',
      colors: _colors,
      children: [
        SettingsTile(
          icon: Icons.person_outline_rounded,
          title: 'Profilo e account',
          subtitle: 'Gestisci le informazioni del tuo account',
          iconColor: _colors.primaryAction,
          colors: _colors,
          enabled: false,
          showChevron: false,
        ),
        SettingsTile(
          icon: Icons.lock_outline_rounded,
          title: 'Cambia password',
          subtitle: 'Aggiorna la password del tuo account',
          iconColor: _colors.primaryAction,
          colors: _colors,
          enabled: false,
          showChevron: false,
        ),
        SettingsTile(
          icon: Icons.logout_rounded,
          title: "Esci dall'account",
          subtitle: 'Termina la sessione corrente',
          iconColor: _colors.dangerAction,
          colors: _colors,
          isDestructive: true,
          showChevron: false,
          onTap: () async {
            await _handleLogout();
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return SettingsSection(
      title: 'Notifiche',
      colors: _colors,
      children: [
        SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: 'Preferenze notifiche',
          subtitle: 'Gestisci gli avvisi relativi a linee, viabilità e viaggio',
          iconColor: _colors.primaryAction,
          colors: _colors,
          showChevron: false,
        ),
      ],
    );
  }

  Widget _buildPrivacyAndSupportSection() {
    return SettingsSection(
      title: 'Privacy e assistenza',
      colors: _colors,
      children: [
        SettingsTile(
          icon: Icons.shield_outlined,
          title: 'Privacy e gestione dei dati',
          subtitle: 'Scopri come vengono trattati i tuoi dati',
          iconColor: _colors.primaryAction,
          colors: _colors,
          showChevron: false,
        ),
        SettingsTile(
          icon: Icons.admin_panel_settings_outlined,
          title: "Permessi dell'app",
          subtitle: 'Posizione, notifiche e accessi autorizzati',
          iconColor: _colors.primaryAction,
          colors: _colors,
          showChevron: false,
        ),
        SettingsTile(
          icon: Icons.support_agent_rounded,
          title: 'Assistenza',
          subtitle: 'FAQ, supporto e contatti',
          iconColor: _colors.primaryAction,
          colors: _colors,
          showChevron: false,
        ),
        SettingsTile(
          icon: Icons.report_problem_outlined,
          title: 'Segnala un problema',
          subtitle: "Comunica malfunzionamenti dell'app",
          iconColor: _colors.primaryAction,
          colors: _colors,
          showChevron: false,
        ),
      ],
    );
  }
}
