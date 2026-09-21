import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Imposta una superficie verticale e la ripristina al termine del test.
Future<void> usePhoneSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(430, 932));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

/// Trova un campo tramite la sua etichetta visibile.
Finder textField(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
);

/// Porta il controllo nell'area visibile prima di premerlo.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
