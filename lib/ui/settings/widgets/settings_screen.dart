import 'package:flutter/material.dart';

import '../../../domain/models/app_user.dart';
import '../theme/settings_colors.dart';
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

  static const SettingsColors _colors = SettingsColors();

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
              const SizedBox(height: 24),
              _buildInformationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(SettingsViewModel viewModel) => SettingsSection(
    title: 'Account',
    colors: _colors,
    children: [
      if (viewModel.isGuest)
        _buildTile(
          icon: Icons.login_rounded,
          title: 'Accedi o registrati',
          subtitle: 'Salva le preferenze e personalizza JiVaio',
          showChevron: true,
          onTap: onLogout,
        )
      else ...[
        _buildTile(
          icon: Icons.person_outline_rounded,
          title: 'Profilo e account',
          subtitle: 'Gestisci le informazioni del tuo account',
        ),
        _buildTile(
          icon: Icons.lock_outline_rounded,
          title: 'Cambia password',
          subtitle: 'Aggiorna la password del tuo account',
        ),
        _buildTile(
          icon: Icons.logout_rounded,
          title: "Esci dall'account",
          subtitle: 'Termina la sessione corrente',
          isDestructive: true,
          onTap: onLogout,
        ),
      ],
    ],
  );

  Widget _buildNotificationsSection() => SettingsSection(
    title: 'Notifiche',
    colors: _colors,
    children: [
      _buildTile(
        icon: Icons.notifications_none_rounded,
        title: 'Preferenze notifiche',
        subtitle: 'Gestisci gli avvisi relativi a linee, viabilità e viaggio',
      ),
    ],
  );

  Widget _buildPrivacyAndSupportSection() => SettingsSection(
    title: 'Privacy e assistenza',
    colors: _colors,
    children: [
      _buildTile(
        icon: Icons.shield_outlined,
        title: 'Privacy e gestione dei dati',
        subtitle: 'Scopri come vengono trattati i tuoi dati',
      ),
      _buildTile(
        icon: Icons.admin_panel_settings_outlined,
        title: "Permessi dell'app",
        subtitle: 'Posizione, notifiche e accessi autorizzati',
      ),
      _buildTile(
        icon: Icons.support_agent_rounded,
        title: 'Assistenza',
        subtitle: 'FAQ, supporto e contatti',
      ),
      _buildTile(
        icon: Icons.report_problem_outlined,
        title: 'Segnala un problema',
        subtitle: "Comunica malfunzionamenti dell'app",
      ),
    ],
  );

  Widget _buildInformationSection() => SettingsSection(
    title: 'Informazioni',
    colors: _colors,
    children: [
      _buildTile(
        icon: Icons.info_outline_rounded,
        title: 'Informazioni su JiVaio',
        subtitle: 'Scopri il progetto e i suoi obiettivi',
      ),
      _buildTile(
        icon: Icons.groups_outlined,
        title: 'Team di sviluppo',
        subtitle: 'Master Mobile Devs',
      ),
      _buildTile(
        icon: Icons.description_outlined,
        title: 'Licenze software',
        subtitle: 'Pacchetti e componenti utilizzati',
      ),
      _buildTile(
        icon: Icons.code_rounded,
        title: 'Versione app',
        subtitle: '1.0.0',
      ),
    ],
  );

  SettingsTile _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showChevron = false,
    bool isDestructive = false,
  }) => SettingsTile(
    icon: icon,
    title: title,
    subtitle: subtitle,
    iconColor: isDestructive ? _colors.dangerAction : _colors.primaryAction,
    colors: _colors,
    onTap: onTap,
    showChevron: showChevron,
    isDestructive: isDestructive,
  );
}
