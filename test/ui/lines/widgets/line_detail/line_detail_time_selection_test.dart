import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_time_filter.dart';

void main() {
  group('LineDetailTimeSelection', () {
    test('crea una selezione automatica', () {
      const selection = LineDetailTimeSelection.automatic();

      expect(selection.isAutomatic, isTrue);
      expect(selection.hour, isNull);
    });

    test('crea una selezione manuale con ora specifica', () {
      const selection = LineDetailTimeSelection.manual(8);

      expect(selection.isAutomatic, isFalse);
      expect(selection.hour, 8);
    });
  });
}