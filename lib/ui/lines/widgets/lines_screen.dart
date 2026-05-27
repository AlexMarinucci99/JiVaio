import 'package:flutter/material.dart';

import '../../../domain/models/transit_line.dart';
import '../../core/widgets/app_segmented_control.dart';
import '../view_model/lines_view_model.dart';
import 'line_card/line_card.dart';
import 'line_detail/line_detail_screen.dart';

class LinesScreen extends StatefulWidget {
  const LinesScreen({
    super.key,
    required this.isGuest,
  });

  // true = utente ospite: può consultare le linee, ma non salvarle.
  // false = utente registrato: può salvare/rimuovere linee preferite.
  final bool isGuest;

  @override
  State<LinesScreen> createState() => _LinesScreenState();
}

class _LinesScreenState extends State<LinesScreen> {
  final LinesViewModel _viewModel = LinesViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // Apertura schermata dettaglio linea.
  void _openLineDetails(TransitLine line) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LineDetailScreen(line: line),
      ),
    );
  }

  // Gestione salvataggio linea.
  // Se l'utente è guest, non modifichiamo lo stato dei preferiti.
  void _toggleSavedLine(String routeId) {
    if (widget.isGuest) {
      _showGuestSaveMessage();
      return;
    }

    _viewModel.toggleSavedLine(routeId);
  }

  void _showGuestSaveMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accedi per salvare le linee preferite.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6FAFF),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF6FAFF), Color(0xFFF2F6FC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header superiore: titolo, sottotitolo e switch.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titolo pagina.
                        Text(
                          'Elenco Linee',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFF111827),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                        ),

                        const SizedBox(height: 4),

                        // Sottotitolo pagina.
                        Text(
                          _viewModel.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF5D6675),
                                fontSize: 12,
                                height: 1.25,
                              ),
                        ),

                        const SizedBox(height: 18),

                        // Switch Tutte / Salvate.
                        // Usa una palette propria della schermata linee.
                        AppSegmentedControl<LinesScope>(
                          selectedValue: _viewModel.scope,
                          onChanged: _viewModel.setScope,
                          colors: const AppSegmentedControlColors(
                            backgroundColor: Color(0xFFEAF0FA),
                            selectedColor: Color(0xFF061A3A),
                            borderColor: Color(0xFFDCE5F2),
                            selectedTextColor: Colors.white,
                            unselectedTextColor: Color(0xFF5D6675),
                            badgeBackgroundColor: Color(0xFFDCEBFF),
                            badgeTextColor: Color(0xFF061A3A),
                            selectedBadgeBackgroundColor: Color(0x2EFFFFFF),
                            selectedBadgeTextColor: Colors.white,
                          ),
                          items: [
                            const AppSegmentedControlItem(
                              value: LinesScope.all,
                              label: 'Tutte',
                            ),
                            AppSegmentedControlItem(
                              value: LinesScope.saved,
                              label: 'Salvate',
                              badgeLabel: _viewModel.savedLinesCount > 0
                                  ? '${_viewModel.savedLinesCount}'
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contenuto tab selezionata.
                  Expanded(child: _buildSelectedContent()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedContent() {
    final lines = _viewModel.visibleLines;

    if (lines.isEmpty) {
      return _SavedLinesEmptyArea(isGuest: widget.isGuest);
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 120),
      itemCount: lines.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final line = lines[index];

        return LineCard(
          key: ValueKey(line.routeId),
          line: line,
          isSaved: _viewModel.isLineSaved(line.routeId),
          onToggleSaved: () => _toggleSavedLine(line.routeId),
          onOpenDetails: () => _openLineDetails(line),
        );
      },
    );
  }
}

class _SavedLinesEmptyArea extends StatelessWidget {
  const _SavedLinesEmptyArea({
    required this.isGuest,
  });

  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 120),
      children: [
        _MessageCard(
          title: isGuest
              ? 'Preferiti disponibili dopo l’accesso'
              : 'Nessuna linea salvata',
          body: isGuest
              ? 'Accedi o registrati per salvare le linee che usi più spesso.'
              : 'Tocca il cuore su una linea nella tab Tutte per ritrovarla qui.',
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EAF2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titolo stato vuoto.
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF111827),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          // Descrizione stato vuoto.
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5D6675),
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}