import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../view_model/line_detail_view_model.dart';
import '../line_card/line_card_colors.dart';
import 'line_detail_header.dart';

class LineDetailScreen extends StatefulWidget {
  const LineDetailScreen({
    super.key,
    required this.line,
  });

  final TransitLine line;

  @override
  State<LineDetailScreen> createState() => _LineDetailScreenState();
}

class _LineDetailScreenState extends State<LineDetailScreen> {
  late final LineDetailViewModel _viewModel;

  // Palette privata della schermata dettaglio linea.
  static const _LineDetailScreenColors _colors = _LineDetailScreenColors();

  @override
  void initState() {
    super.initState();

    _viewModel = LineDetailViewModel(
      line: widget.line,
      colors: _colors.linePalette,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _closeDetail() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
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
              child: Column(
                children: [
                  // Header fisso superiore.
                  LineDetailHeader(
                    line: _viewModel.line,
                    direction: _viewModel.selectedDirection,
                    lineColor: _viewModel.lineColor,
                    canSwapDirection: _viewModel.canSwapDirection,
                    onSwapDirection: _viewModel.toggleDirection,
                    onClose: _closeDetail,
                    colors: _viewModel.colors,
                  ),

                  const SizedBox(height: 12),

                  // Per ora il corpo rimane vuoto.
                  const Expanded(
                    child: SizedBox.expand(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Colori specifici della schermata dettaglio linea.
class _LineDetailScreenColors {
  const _LineDetailScreenColors();

  final Color backgroundColor = const Color(0xFFF6FAFF);

  // Palette condivisa con la feature linee.
  // Non modifica il colore del badge: quello resta derivato da line.routeColor.
  final LineCardPalette linePalette = LineCardColors.defaultPalette;
}