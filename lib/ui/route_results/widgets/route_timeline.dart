import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Timeline verticale del percorso consigliato.
///
/// Il widget riceve una sequenza ordinata di passaggi e li mostra
/// senza calcolare autonomamente tempi, linee o fermate.
class RouteTimeline extends StatelessWidget {
  const RouteTimeline({super.key, required this.steps, required this.colors});

  final List<RouteStep> steps;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return Text(
        'Dettagli del percorso non disponibili.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colors.textSecondaryColor),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          _TimelineStepTile(
            step: steps[index],
            colors: colors,
            isLast: index == steps.length - 1,
          ),
      ],
    );
  }
}

class _TimelineStepTile extends StatelessWidget {
  const _TimelineStepTile({
    required this.step,
    required this.colors,
    required this.isLast,
  });

  final RouteStep step;
  final RouteResultsColors colors;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 46,
          child: Column(
            children: [
              _TimelineMarker(stepType: step.type, colors: colors),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _TimelineConnector(
                    isDotted: _usesDottedConnector(step.type),
                    colors: colors,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useCompactLayout = constraints.maxWidth < 250;

                if (useCompactLayout) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StepDescription(step: step, colors: colors),
                      const SizedBox(height: 8),
                      _StepMetadata(
                        step: step,
                        colors: colors,
                        alignment: CrossAxisAlignment.start,
                        textAlign: TextAlign.start,
                      ),
                      if (!isLast) ...[
                        const SizedBox(height: 16),
                        Divider(height: 1, color: colors.borderColor),
                      ],
                    ],
                  );
                }

                final metadataWidth = constraints.maxWidth < 320 ? 112.0 : 138.0;

                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _StepDescription(step: step, colors: colors),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: metadataWidth,
                          child: _StepMetadata(
                            step: step,
                            colors: colors,
                            alignment: CrossAxisAlignment.end,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    if (!isLast) ...[
                      const SizedBox(height: 16),
                      Divider(height: 1, color: colors.borderColor),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _usesDottedConnector(RouteStepType type) {
    return type == RouteStepType.departure || type == RouteStepType.walk;
  }
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({required this.stepType, required this.colors});

  final RouteStepType stepType;
  final RouteResultsColors colors;

  IconData get _icon {
    switch (stepType) {
      case RouteStepType.departure:
        return Icons.my_location_rounded;
      case RouteStepType.walk:
        return Icons.directions_walk_rounded;
      case RouteStepType.wait:
        return Icons.hourglass_bottom_rounded;
      case RouteStepType.bus:
        return Icons.directions_bus_filled_rounded;
      case RouteStepType.destination:
        return Icons.location_on_rounded;
    }
  }

  Color get _foregroundColor {
    switch (stepType) {
      case RouteStepType.departure:
        return colors.departureMarkerColor;
      case RouteStepType.destination:
        return colors.arrivalMarkerColor;
      case RouteStepType.walk:
      case RouteStepType.wait:
      case RouteStepType.bus:
        return colors.accentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        shape: BoxShape.circle,
        border: Border.all(color: _foregroundColor, width: 2),
      ),
      child: Icon(_icon, size: 21, color: _foregroundColor),
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  const _TimelineConnector({required this.isDotted, required this.colors});

  final bool isDotted;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 3,
      height: 46,
      child: CustomPaint(
        painter: _TimelineConnectorPainter(
          color: colors.accentColor,
          isDotted: isDotted,
        ),
      ),
    );
  }
}

class _TimelineConnectorPainter extends CustomPainter {
  const _TimelineConnectorPainter({
    required this.color,
    required this.isDotted,
  });

  final Color color;
  final bool isDotted;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final x = size.width / 2;

    if (!isDotted) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      return;
    }

    const dashHeight = 5.0;
    const dashSpacing = 5.0;

    var currentY = 0.0;

    while (currentY < size.height) {
      final endY = (currentY + dashHeight).clamp(0.0, size.height);

      canvas.drawLine(Offset(x, currentY), Offset(x, endY), paint);

      currentY += dashHeight + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant _TimelineConnectorPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isDotted != isDotted;
  }
}

class _StepDescription extends StatelessWidget {
  const _StepDescription({required this.step, required this.colors});

  final RouteStep step;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              step.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.textPrimaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (step.lineCode != null)
              _LineCodeBadge(lineCode: step.lineCode!, colors: colors),
          ],
        ),
        if (step.subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            step.subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondaryColor,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}

class _LineCodeBadge extends StatelessWidget {
  const _LineCodeBadge({required this.lineCode, required this.colors});

  final String lineCode;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 32),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.accentSoftColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.accentBorderColor),
      ),
      child: Text(
        lineCode,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: colors.accentColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StepMetadata extends StatelessWidget {
  const _StepMetadata({
    required this.step,
    required this.colors,
    required this.alignment,
    required this.textAlign,
  });

  final RouteStep step;
  final RouteResultsColors colors;
  final CrossAxisAlignment alignment;
  final TextAlign textAlign;

  String get _mainText {
    final duration = step.duration;

    if (duration != null) {
      return '${duration.inMinutes} min';
    }

    return step.scheduledTime ?? '';
  }

  List<String> get _secondaryLines {
    switch (step.type) {
      case RouteStepType.departure:
        return [if (step.scheduledTime != null) 'Orario di partenza'];

      case RouteStepType.walk:
        return [if (step.scheduledTime != null) 'Arrivo ${step.scheduledTime}'];

      case RouteStepType.wait:
      case RouteStepType.bus:
        return [
          if (step.scheduledTime != null)
            'Orario ufficiale ${step.scheduledTime}',
          if (step.estimatedTime != null)
            'Orario stimato ${step.estimatedTime}'
          else
            'Orario stimato non disponibile',
        ];

      case RouteStepType.destination:
        return [
          if (step.estimatedTime != null)
            'Orario stimato ${step.estimatedTime}'
          else
            'Orario stimato non disponibile',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (_mainText.isNotEmpty)
          Text(
            _mainText,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.textPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        if (_secondaryLines.isNotEmpty) const SizedBox(height: 4),
        for (final line in _secondaryLines)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              line,
              textAlign: textAlign,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondaryColor,
                height: 1.25,
              ),
            ),
          ),
      ],
    );
  }
}
