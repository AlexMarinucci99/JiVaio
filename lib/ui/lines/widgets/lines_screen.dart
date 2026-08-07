import 'package:flutter/material.dart';
import '../../../data/repositories/saved_lines_repository.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_line.dart';
import '../../core/widgets/app_segmented_control.dart';
import '../view_model/lines_view_model.dart';
import 'line_card/line_card.dart';
import 'line_detail/line_detail_screen.dart';
import '../theme/lines_screen_colors.dart';

/// Schermata che mostra l'elenco delle linee urbane.
///
/// Permette di consultare tutte le linee, filtrare quelle salvate
/// e aprire il dettaglio di una linea selezionata.
class LinesScreen extends StatefulWidget {
  const LinesScreen({
    super.key,
    required this.isGuest,
    required this.userId,
    required this.repository,
    required this.savedLinesRepository,
  }) : assert(isGuest || userId != null);

  /// Indica se la schermata è usata da un utente ospite.
  ///
  /// In modalità guest l'utente può consultare le linee,
  /// ma non può modificarne lo stato di salvataggio.
  final bool isGuest;

  /// Identificativo Firebase dell'utente autenticato.
  ///
  /// È null soltanto quando [isGuest] è true.
  final String? userId;

  /// Repository usato per recuperare linee e dettagli di percorso.
  final TransitRepository repository;

  /// Repository usato per leggere e aggiornare le linee salvate.
  final SavedLinesRepository savedLinesRepository;

  @override
  State<LinesScreen> createState() => _LinesScreenState();
}

class _LinesScreenState extends State<LinesScreen> {
  static const LinesScreenColors _colors = LinesScreenColors();

  late final LinesViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = LinesViewModel(
      transitRepository: widget.repository,
      savedLinesRepository: widget.savedLinesRepository,
      userId: widget.userId,
    );

    _viewModel.loadLines();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openLineDetails(TransitLine line) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            LineDetailScreen(line: line, repository: widget.repository),
      ),
    );
  }

  Future<void> _toggleSavedLine(String routeId) async {
    if (widget.isGuest) {
      _showGuestSaveMessage();
      return;
    }

    final success = await _viewModel.toggleSavedLine(routeId);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossibile aggiornare le linee salvate. Riprova.'),
        ),
      );
    }
  }

  void _showGuestSaveMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Accedi per salvare le linee preferite.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Elenco Linee',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: _colors.primaryText,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _viewModel.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _colors.secondaryText,
                                fontSize: 12,
                                height: 1.25,
                              ),
                        ),
                        const SizedBox(height: 18),
                        AppSegmentedControl<LinesScope>(
                          selectedValue: _viewModel.scope,
                          onChanged: _viewModel.setScope,
                          colors: _colors.segmentedControlColors,
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
    if (_viewModel.isLoading && _viewModel.allLines.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null && _viewModel.allLines.isEmpty) {
      return _LinesStateArea(
        key: const ValueKey('lines-error-state'),
        title: 'Errore caricamento linee',
        message: _viewModel.errorMessage!,
        colors: _colors,
        action: FilledButton(
          onPressed: _viewModel.loadLines,
          child: const Text('Riprova'),
        ),
      );
    }

    final lines = _viewModel.visibleLines;

    if (lines.isEmpty) {
      return _LinesStateArea(
        key: const ValueKey('lines-empty-state'),
        title: widget.isGuest
            ? 'Preferiti disponibili dopo l’accesso'
            : 'Nessuna linea salvata',
        message: widget.isGuest
            ? 'Accedi o registrati per salvare le linee che usi più spesso.'
            : 'Tocca il cuore su una linea nella tab Tutte per ritrovarla qui.',
        colors: _colors,
      );
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

class _LinesStateArea extends StatelessWidget {
  const _LinesStateArea({
    super.key,
    required this.title,
    required this.message,
    required this.colors,
    this.action,
  });

  final String title;
  final String message;
  final LinesScreenColors colors;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 120),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.stateCardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.stateCardBorder),
            boxShadow: [
              BoxShadow(
                color: colors.stateCardShadow.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.secondaryText,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: 14),
                action,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
