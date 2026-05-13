import 'package:flutter/material.dart';

import '../../core/widgets/app_segmented_control.dart';
import '../view_model/lines_view_model.dart';

class LinesScreen extends StatefulWidget {
  const LinesScreen({super.key});

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
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: const Color(0xFF111827),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),

                        const SizedBox(height: 4),

                        // Sottotitolo pagina.
                        Text(
                          _viewModel.subtitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF5D6675),
                                    fontSize: 12,
                                    height: 1.25,
                                  ),
                        ),

                        const SizedBox(height: 18),

                        // Widget condiviso: switch Tutte / Salvate.
                        AppSegmentedControl<LinesScope>(
                          selectedValue: _viewModel.scope,
                          onChanged: _viewModel.setScope,
                          items: const [
                            AppSegmentedControlItem(
                              value: LinesScope.all,
                              label: 'Tutte',
                            ),
                            AppSegmentedControlItem(
                              value: LinesScope.saved,
                              label: 'Salvate',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contenuto della tab selezionata.
                  Expanded(
                    child: _buildSelectedContent(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedContent() {
    if (_viewModel.scope == LinesScope.all) {
      return const _AllLinesEmptyArea();
    }

    return const _SavedLinesEmptyArea();
  }
}

class _AllLinesEmptyArea extends StatelessWidget {
  const _AllLinesEmptyArea();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 120),
      children: const [
        // Qui nel prossimo step inseriremo le card delle linee bus.
        SizedBox(height: 1),
      ],
    );
  }
}

class _SavedLinesEmptyArea extends StatelessWidget {
  const _SavedLinesEmptyArea();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 120),
      children: const [
        _MessageCard(
          title: 'Nessuna linea salvata',
          body: 'Tocca il cuore su una linea nella tab Tutte per ritrovarla qui.',
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5EAF2),
        ),
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