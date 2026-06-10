import 'package:flutter/material.dart';
import '../../../data/repositories/saved_lines_repository.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_line.dart';
import '../../core/widgets/app_segmented_control.dart';
import '../view_model/lines_view_model.dart';
import 'line_card/line_card.dart';
import 'line_detail/line_detail_screen.dart';
import '../theme/lines_screen_colors.dart';

class LinesScreen extends StatefulWidget {
  const LinesScreen({
    super.key,
    required this.isGuest,
    required this.userId,
    required this.repository,
    required this.savedLinesRepository,
  }) : assert(isGuest || userId != null);

  // true = utente ospite: può consultare le linee, ma non salvarle.
  // false = utente registrato: può salvare/rimuovere linee preferite.
  final bool isGuest;

  // UID Firebase dell'utente autenticato.
  // È null soltanto per il guest.
  final String? userId;

  final TransitRepository repository;

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

  // Gestione salvataggio linea.
  // Se l'utente è guest, non modifichiamo lo stato dei preferiti.
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
                                color: _colors.titleText,
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
      return _ErrorLinesArea(
        message: _viewModel.errorMessage!,
        onRetry: _viewModel.loadLines,
        colors: _colors,
      );
    }

    final lines = _viewModel.visibleLines;

    if (lines.isEmpty) {
      return _SavedLinesEmptyArea(isGuest: widget.isGuest, colors: _colors);
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

class _ErrorLinesArea extends StatelessWidget {
  const _ErrorLinesArea({
    required this.message,
    required this.onRetry,
    required this.colors,
  });

  final String message;
  final Future<void> Function() onRetry;
  final LinesScreenColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 120),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Errore caricamento linee',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.titleText,
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
              const SizedBox(height: 14),
              FilledButton(onPressed: onRetry, child: const Text('Riprova')),
            ],
          ),
        ),
      ],
    );
  }
}

class _SavedLinesEmptyArea extends StatelessWidget {
  const _SavedLinesEmptyArea({required this.isGuest, required this.colors});

  final bool isGuest;
  final LinesScreenColors colors;

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
          colors: colors,
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.title,
    required this.body,
    required this.colors,
  });

  final String title;
  final String body;
  final LinesScreenColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow.withValues(alpha: 0.06),
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
              color: colors.titleText,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.secondaryText,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
