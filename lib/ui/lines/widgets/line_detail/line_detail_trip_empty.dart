import 'package:flutter/material.dart';

import '../../theme/line_detail_colors.dart';

class LineDetailTripEmpty extends StatelessWidget {
  const LineDetailTripEmpty({
    super.key,
    required this.message,
    required this.textColor,
  });

  final String message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: LineDetailColors.warningSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
