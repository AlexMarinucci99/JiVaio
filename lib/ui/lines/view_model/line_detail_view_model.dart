
import 'package:flutter/material.dart';

import '../../../domain/models/transit_line.dart';
import '../widgets/line_card/line_card_colors.dart';

class LineDetailViewModel extends ChangeNotifier {
  LineDetailViewModel({
    required TransitLine line,
    this.colors = LineCardColors.defaultPalette,
  }) : _line = line;

  final TransitLine _line;

  // Palette condivisa con la feature linee.
  // Non modifica il colore del badge: quello resta derivato da line.routeColor.
  final LineCardPalette colors;

  int _selectedDirectionIndex = 0;

  TransitLine get line => _line;

  int get selectedDirectionIndex => _selectedDirectionIndex;

  Color get lineColor {
    return LineCardColors.parseLineColor(
      _line.routeColor,
      colors: colors,
    );
  }

  bool get hasDirections {
    return _line.directions.isNotEmpty;
  }

  bool get canSwapDirection {
    return _line.directions.length > 1;
  }

  bool get canToggleDirection {
    return canSwapDirection && !_line.isUnidirectional;
  }

  TransitLineDirection? get selectedDirection {
    if (_line.directions.isEmpty) {
      return null;
    }

    if (_selectedDirectionIndex >= _line.directions.length) {
      return _line.directions.first;
    }

    return _line.directions[_selectedDirectionIndex];
  }

  void toggleDirection() {
    if (!canToggleDirection) {
      return;
    }

    _selectedDirectionIndex =
        (_selectedDirectionIndex + 1) % _line.directions.length;

    notifyListeners();
  }
}