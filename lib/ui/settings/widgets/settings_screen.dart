import 'package:flutter/material.dart';

import '../../../domain/models/app_user.dart';
import '../theme/settings_colors.dart';
import '../view_model/settings_view_model.dart';
import 'settings_profile_card.dart';
import 'settings_section.dart';
import 'settings_tile.dart';

/// Riceve l'utente autenticato, oppure null in modalità guest,
/// e mostra le voci disponibili per il relativo profilo.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.user, required this.onLogout});

  final AppUser? user;

  /// Per un utente autenticato esegue il logout.
  ///
  /// Per un guest ritorna alla schermata di accesso.
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final viewModel = SettingsViewModel(user: user);

    return Scaffold(
      backgroundColor: SettingsColors.pageBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [SettingsColors.gradientStart, SettingsColors.gradientEnd],
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
                  color: SettingsColors.titleText,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              SettingsProfileCard(
                title: viewModel.profileTitle,
                subtitle: viewModel.profileSubtitle,
                isGuest: viewModel.isGuest,
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
    children: [
      if (viewModel.isGuest)
        SettingsTile(
          icon: Icons.login_rounded,
          title: 'Accedi o registrati',
          subtitle: 'Salva le preferenze e personalizza JiVaio',
          onTap: onLogout,
        )
      else ...[
        const SettingsTile(
          icon: Icons.person_outline_rounded,
          title: 'Profilo e account',
          subtitle: 'Gestisci le informazioni del tuo account',
        ),
        const SettingsTile(
          icon: Icons.lock_outline_rounded,
          title: 'Cambia password',
          subtitle: 'Aggiorna la password del tuo account',
        ),
        SettingsTile(
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
    children: [
      SettingsTile(
        icon: Icons.notifications_none_rounded,
        title: 'Preferenze notifiche',
        subtitle: 'Gestisci gli avvisi relativi a linee, viabilità e viaggio',
      ),
    ],
  );

  Widget _buildPrivacyAndSupportSection() => SettingsSection(
    title: 'Privacy e assistenza',
    children: [
      SettingsTile(
        icon: Icons.shield_outlined,
        title: 'Privacy e gestione dei dati',
        subtitle: 'Scopri come vengono trattati i tuoi dati',
      ),
      SettingsTile(
        icon: Icons.admin_panel_settings_outlined,
        title: "Permessi dell'app",
        subtitle: 'Posizione, notifiche e accessi autorizzati',
      ),
      SettingsTile(
        icon: Icons.support_agent_rounded,
        title: 'Assistenza',
        subtitle: 'FAQ, supporto e contatti',
      ),
      SettingsTile(
        icon: Icons.report_problem_outlined,
        title: 'Segnala un problema',
        subtitle: "Comunica malfunzionamenti dell'app",
      ),
    ],
  );

  Widget _buildInformationSection() => SettingsSection(
    title: 'Informazioni',
    children: [
      SettingsTile(
        icon: Icons.info_outline_rounded,
        title: 'Informazioni su JiVaio',
        subtitle: 'Scopri il progetto e i suoi obiettivi',
      ),
      SettingsTile(
        icon: Icons.groups_outlined,
        title: 'Team di sviluppo',
        subtitle: 'Master Mobile Devs',
      ),
      SettingsTile(
        icon: Icons.description_outlined,
        title: 'Licenze software',
        subtitle: 'Pacchetti e componenti utilizzati',
      ),
      SettingsTile(
        icon: Icons.code_rounded,
        title: 'Versione app',
        subtitle: '1.0.0',
      ),
    ],
  );
}
