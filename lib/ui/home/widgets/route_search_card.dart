import 'package:flutter/material.dart';

import '../theme/home_colors.dart';

/// Mostra la card di ricerca del percorso nella home.
///
/// La card raccoglie partenza e destinazione, abilita la ricerca
/// quando entrambi i campi sono compilati e delega l'azione tramite [onSearch].
class RouteSearchCard extends StatefulWidget {
  const RouteSearchCard({
    super.key,

    this.contentScale = 0.90,
    this.onSearch,
    this.colors = const RouteSearchCardColors(),
  }) : assert(contentScale > 0);

  /// Fattore di scala applicato agli elementi interni della card.
  final double contentScale;

  /// Callback invocata quando l'utente richiede la ricerca del percorso.
  ///
  /// Nel prototipo corrente la card non calcola il percorso.
  /// La ricerca viene avviata solo quando partenza e destinazione sono compilate.
  final void Function(String from, String to)? onSearch;

  /// Palette cromatica usata dalla card.
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

    if (from.trim().isEmpty && to.trim().isEmpty) return;

    setState(() {
      _fromController.text = to;
      _toController.text = from;
    });
  }

  void _searchRoute() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) return;

    widget.onSearch?.call(from, to);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.contentScale;
    final colors = widget.colors;
    final canSearch = _canSearch;

    return Container(
      padding: EdgeInsets.only(
        left: 14 * scale,
        right: 14 * scale,
        bottom: 13 * scale,
      ),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(22 * scale),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: Offset(0, 10 * scale),
            child: _SearchTextField(
              fieldKey: const Key('route-search-from-field'),
              label: 'Da',
              controller: _fromController,
              icon: Icons.navigation_rounded,
              hintText: 'Da dove vuoi partire?',
              scale: scale,
              colors: colors,
              onChanged: _refreshCard,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5 * scale),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 28 * scale,
                    color: colors.dividerColor,
                  ),
                ),
                IconButton(
                  key: const Key('route-search-swap-button'),
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
          ),
          _SearchTextField(
            fieldKey: const Key('route-search-to-field'),
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
              key: const Key('route-search-submit-button'),
              onPressed: canSearch ? _searchRoute : null,
              style: FilledButton.styleFrom(
                backgroundColor: colors.activeButtonColor,
                foregroundColor: colors.activeButtonTextColor,
                disabledBackgroundColor: colors.inactiveButtonColor,
                disabledForegroundColor: colors.inactiveTextColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
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
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.scale,
    required this.colors,
    required this.onChanged,
  });

  final Key fieldKey;
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
                key: fieldKey,
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
