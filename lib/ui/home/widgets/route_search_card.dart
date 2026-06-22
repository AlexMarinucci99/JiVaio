import 'package:flutter/material.dart';

import '../theme/home_colors.dart';

/// Mostra la card di ricerca del percorso nella home.
///
/// La card raccoglie partenza e destinazione, abilita la ricerca
/// quando entrambi i campi sono compilati e delega l'azione tramite [onSearch].
class RouteSearchCard extends StatefulWidget {
  const RouteSearchCard({
    super.key,
    this.width,
    this.contentScale = 0.90,
    this.onSearch,
    this.colors = const RouteSearchCardColors(),
  }) : assert(contentScale > 0);

  /// Larghezza esterna della card.
  ///
  /// Se il valore è null, la card occupa la larghezza disponibile.
  final double? width;

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

  bool get _canSearch {
    return _fromController.text.trim().isNotEmpty &&
        _toController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _fromController.addListener(_refreshCard);
    _toController.addListener(_refreshCard);
  }

  @override
  void dispose() {
    _fromController.removeListener(_refreshCard);
    _toController.removeListener(_refreshCard);

    _fromController.dispose();
    _toController.dispose();

    super.dispose();
  }

  void _refreshCard() {
    setState(() {});
  }

  void _swapFields() {
    final oldFrom = _fromController.text;
    final oldTo = _toController.text;

    if (oldFrom.trim().isEmpty && oldTo.trim().isEmpty) {
      return;
    }

    _fromController.text = oldTo;
    _toController.text = oldFrom;
  }

  void _searchRoute() {
    if (!_canSearch) {
      return;
    }

    widget.onSearch?.call(
      _fromController.text.trim(),
      _toController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.contentScale;
    final colors = widget.colors;

    return SizedBox(
      width: widget.width,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          14 * scale,
          0 * scale,
          14 * scale,
          13 * scale,
        ),
        decoration: BoxDecoration(
          color: colors.cardColor,
          borderRadius: BorderRadius.circular(22 * scale),
          boxShadow: [
            BoxShadow(
              color: colors.shadowColor,
              blurRadius: 24 * scale,
              offset: Offset(0, 10 * scale),
            ),
          ],
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
            ),
            SizedBox(height: 12 * scale),
            SizedBox(
              width: double.infinity,
              height: 50 * scale,
              child: FilledButton.icon(
                key: const Key('route-search-submit-button'),
                onPressed: _canSearch ? _searchRoute : null,
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
                icon: Icon(
                  Icons.navigation_rounded,
                  size: 18 * scale,
                  color: _canSearch
                      ? colors.activeButtonTextColor
                      : colors.inactiveTextColor,
                ),
                label: Text(
                  'Cerca percorso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w700,
                    color: _canSearch
                        ? colors.activeButtonTextColor
                        : colors.inactiveTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
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
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final double scale;
  final RouteSearchCardColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46 * scale,
          height: 46 * scale,
          decoration: BoxDecoration(
            color: colors.iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14 * scale, color: colors.iconColor),
        ),
        SizedBox(width: 14 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.labelColor,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextField(
                key: fieldKey,
                controller: controller,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.textColor,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
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
