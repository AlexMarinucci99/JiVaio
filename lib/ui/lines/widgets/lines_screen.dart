import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/transit_line.dart';
import '../../core/widgets/app_segmented_control.dart';
import '../theme/lines_screen_colors.dart';
import '../view_model/line_detail_view_model.dart';
import '../view_model/lines_view_model.dart';
import 'line_card/line_card.dart';
import 'line_detail/line_detail_screen.dart';

const _colors = LinesScreenColors();

/// Mostra tutte le linee e quelle salvate dall'utente.
class LinesScreen extends StatelessWidget {
  const LinesScreen({super.key});

  void _openLineDetails(BuildContext context, TransitLine line) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<LineDetailViewModel>(
          create: (context) =>
              LineDetailViewModel(line: line, repository: context.read())
                ..loadSchedule(),
          child: const LineDetailScreen(),
        ),
      ),
    );
  }

  Future<void> _toggleSavedLine(
    BuildContext context,
    LinesViewModel viewModel,
    String routeId,
  ) async {
    if (viewModel.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Accedi per salvare le linee preferite.')),
      );
      return;
    }

    final success = await viewModel.toggleSavedLine(routeId);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossibile aggiornare le linee salvate. Riprova.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LinesViewModel>(
      builder: (context, viewModel, child) {
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
                          viewModel.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _colors.secondaryText,
                                fontSize: 12,
                                height: 1.25,
                              ),
                        ),
                        const SizedBox(height: 18),
                        AppSegmentedControl<LinesScope>(
                          selectedValue: viewModel.scope,
                          onChanged: viewModel.setScope,
                          colors: _colors.segmentedControlColors,
                          items: [
                            const AppSegmentedControlItem(
                              value: LinesScope.all,
                              label: 'Tutte',
                            ),
                            AppSegmentedControlItem(
                              value: LinesScope.saved,
                              label: 'Salvate',
                              badgeLabel: viewModel.savedLinesCount > 0
                                  ? '${viewModel.savedLinesCount}'
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildSelectedContent(context, viewModel)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedContent(BuildContext context, LinesViewModel viewModel) {
   
    if (viewModel.errorMessage != null && viewModel.allLines.isEmpty) {
      return _LinesStateArea(
        title: 'Errore caricamento linee',
        message: viewModel.errorMessage!,
        action: FilledButton(
          onPressed: viewModel.loadLines,
          child: const Text('Riprova'),
        ),
      );
    }

    final lines = viewModel.visibleLines;
    if (lines.isEmpty) {
      final isGuest = viewModel.userId == null;
      return _LinesStateArea(
        title: isGuest
            ? 'Preferiti disponibili dopo l’accesso'
            : 'Nessuna linea salvata',
        message: isGuest
            ? 'Accedi o registrati per salvare le linee che usi più spesso.'
            : 'Tocca il cuore su una linea nella tab Tutte per ritrovarla qui.',
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
          isSaved: viewModel.isLineSaved(line.routeId),
          onToggleSaved: () =>
              _toggleSavedLine(context, viewModel, line.routeId),
          onOpenDetails: () => _openLineDetails(context, line),
        );
      },
    );
  }
}

class _LinesStateArea extends StatelessWidget {
  const _LinesStateArea({
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
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
            color: _colors.stateCardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _colors.stateCardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _colors.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _colors.secondaryText,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
              if (action != null) ...[const SizedBox(height: 14), action],
            ],
          ),
        ),
      ],
    );
  }
}
