import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';

void main() {
  test('riconosce e normalizza le linee monodirezionali', () {
    const expectedByShortName = <String, bool>{
      '2U': true,
      ' 2u ': true,
      '2UT': true,
      ' 2ut ': true,
      '1': false,
    };

    for (final entry in expectedByShortName.entries) {
      final line = TransitLine(
        routeId: 'line-${entry.key.trim()}',
        shortName: entry.key,
        displayName: 'Linea ${entry.key.trim()}',
        routeLongName: 'Linea di test',
        routeColor: '0B7A55',
        directions: const [],
      );

      expect(
        line.isUnidirectional,
        entry.value,
        reason: 'Risultato inatteso per shortName "${entry.key}".',
      );
    }
  });
}