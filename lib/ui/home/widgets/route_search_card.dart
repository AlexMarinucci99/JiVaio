import 'package:flutter/material.dart';

import '../theme/home_colors.dart';

/// Mostra la card di ricerca del percorso nella home.
///
/// La card raccoglie partenza e destinazione, abilita la ricerca
/// quando entrambi i campi sono compilati e delega l'azione tramite [onSearch].
class RouteSearchCard extends StatefulWidget {
  const RouteSearchCard({
    super.key,
    required this.onSearch,
    this.colors = const RouteSearchCardColors(),
  });

  /// Callback invocata quando l'utente richiede la ricerca del percorso.
  final void Function(String from, String to) onSearch;
  final RouteSearchCardColors colors;

  @override
  State<RouteSearchCard> createState() => _RouteSearchCardState();
}

class _RouteSearchCardState extends State<RouteSearchCard> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  bool get _canSearch =>
      _fromController.text.trim().isNotEmpty &&
      _toController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _refreshCard(String _) => setState(() {});

  void _swapFields() {
    final (from, to) = (_fromController.text, _toController.text);
    _fromController.text = to;
    _toController.text = from;
  }

  void _searchRoute() {
    widget.onSearch(_fromController.text.trim(), _toController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    const scale = 0.90;
    final colors = widget.colors;
    final canSearch = _canSearch;

    return Container(
      padding: EdgeInsets.all(14 * scale),

      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(22 * scale),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SearchTextField(
            label: 'Da',
            controller: _fromController,
            icon: Icons.navigation_rounded,
            hintText: 'Da dove vuoi partire?',
            scale: scale,
            colors: colors,
            onChanged: _refreshCard,
          ),
          Row(
            children: [
              Expanded(
                child: Divider(height: 28 * scale, color: colors.dividerColor),
              ),
              IconButton(
                onPressed: _swapFields,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: 40 * scale,
                  height: 40 * scale,
                ),
                icon: Icon(
                  Icons.swap_vert_rounded,
                  size: 20 * scale,
                  color: colors.swapIconColor,
                ),
              ),
            ],
          ),
          _SearchTextField(
            label: 'A',
            controller: _toController,
            icon: Icons.place_rounded,
            hintText: 'Dove vuoi andare?',
            scale: scale,
            colors: colors,
            onChanged: _refreshCard,
          ),
          SizedBox(height: 12 * scale),
          SizedBox(
            width: double.infinity,
            height: 50 * scale,
            child: FilledButton.icon(
              onPressed: canSearch ? _searchRoute : null,
              style: FilledButton.styleFrom(
                backgroundColor: colors.activeButtonColor,
                foregroundColor: colors.activeButtonTextColor,
                disabledBackgroundColor: colors.inactiveButtonColor,
                disabledForegroundColor: colors.inactiveTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16 * scale),
                ),
              ),
              icon: Icon(Icons.navigation_rounded, size: 18 * scale),
              label: Text(
                'Cerca percorso',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: canSearch
                      ? colors.activeButtonTextColor
                      : colors.inactiveTextColor,
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.scale,
    required this.colors,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final double scale;
  final RouteSearchCardColors colors;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 14 * scale, color: colors.iconColor),
        SizedBox(width: 14 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: colors.labelColor,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextField(
                controller: controller,
                onChanged: onChanged,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textColor,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: textTheme.titleMedium?.copyWith(
                    color: colors.hintColor,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
