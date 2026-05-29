import 'package:flutter/material.dart';

class RouteSearchCardColors {
  const RouteSearchCardColors({
    this.cardColor = Colors.white,
    this.textColor = const Color(0xFF20232D),
    this.labelColor = const Color(0xFF5C5F6D),
    this.dividerColor = const Color(0xFFE7E8EE),
    this.activeButtonColor = const Color(0xFF17226B),
    this.activeButtonTextColor = Colors.white,
    this.inactiveButtonColor = const Color(0xFFE9E7F0),
    this.inactiveTextColor = const Color(0xFF4F4D59),
    this.iconBackgroundColor = const Color(0xFFF0F1F6),
    this.iconColor = const Color(0xFF59609A),
    this.swapIconColor = const Color(0xFF59609A),
    this.hintColor = const Color(0xFF777986),
    this.shadowColor = const Color(0x1F000000),
  });

  // Colore sfondo della card.
  final Color cardColor;

  // Colore del testo principale dei campi.
  final Color textColor;

  // Colore delle label "Da" e "A".
  final Color labelColor;

  // Colore del divisore centrale.
  final Color dividerColor;

  // Colore del bottone attivo.
  final Color activeButtonColor;

  // Colore testo/icona del bottone attivo.
  final Color activeButtonTextColor;

  // Colore del bottone disattivato.
  final Color inactiveButtonColor;

  // Colore testo/icona del bottone disattivato.
  final Color inactiveTextColor;

  // Colore sfondo cerchio icona dei campi.
  final Color iconBackgroundColor;

  // Colore icona dei campi.
  final Color iconColor;

  // Colore icona per invertire partenza/destinazione.
  final Color swapIconColor;

  // Colore placeholder dei campi.
  final Color hintColor;

  // Colore ombra della card.
  final Color shadowColor;
}

class RouteSearchCard extends StatefulWidget {
  const RouteSearchCard({
    super.key,
    this.width,
    this.contentScale = 0.90,
    this.onSearch,
    this.colors = const RouteSearchCardColors(),
  }) : assert(contentScale > 0);

  // Larghezza esterna della card.
  // Se resta null, la card prende la larghezza disponibile dal parent.
  final double? width;

  // Scala generale del contenuto interno.
  // 1.0 = dimensione normale
  // 0.90 = contenuto più piccolo.
  final double contentScale;

  // Funzione chiamata quando l'utente preme il bottone Cerca percorso.
  // Per ora non contiene logica di routing: serve solo come aggancio futuro.
  final void Function(String from, String to)? onSearch;

  // Palette colori propria della card.
  final RouteSearchCardColors colors;

  @override
  State<RouteSearchCard> createState() => _RouteSearchCardState();
}

class _RouteSearchCardState extends State<RouteSearchCard> {
  // =========================
  // CONTROLLER DEI CAMPI
  // =========================
  // Servono per leggere e modificare il testo scritto dall'utente.
  final TextEditingController _fromController = TextEditingController(
    text: 'Posizione attuale',
  );

  final TextEditingController _toController = TextEditingController();

  // =========================
  // STATO DEL BOTTONE
  // =========================
  // Il bottone si attiva solo quando entrambi i campi contengono testo.
  bool get _canSearch {
    return _fromController.text.trim().isNotEmpty &&
        _toController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    // Ogni volta che cambia il testo, aggiorniamo la UI.
    // Serve per cambiare colore/stato del bottone.
    _fromController.addListener(_refreshCard);
    _toController.addListener(_refreshCard);
  }

  @override
  void dispose() {
    // Pulizia dei controller quando il widget viene eliminato.
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _refreshCard() {
    setState(() {});
  }

  void _swapFields() {
    // Inverte partenza e destinazione.
    final oldFrom = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = oldFrom;
  }

  void _searchRoute() {
    // Per ora il bottone non calcola il percorso.
    // Passa solo i valori verso l'esterno.
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
    // =========================
    // SCALA GENERALE
    // =========================
    // Cambiando contentScale, ridimensioni il contenuto interno della card.
    final scale = widget.contentScale;
    final colors = widget.colors;

    return SizedBox(
      // Qui cambi la larghezza esterna della card.
      width: widget.width,

      child: Container(
        // =========================
        // STRUTTURA ESTERNA CARD
        // =========================
        // Questo padding cambia lo spazio interno della card.
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
            // =========================
            // CAMPO PARTENZA - DA
            // =========================
            Transform.translate(
              offset: Offset(0, 10 * scale),
              child: _SearchTextField(
                label: 'Da',
                controller: _fromController,
                icon: Icons.navigation_rounded,
                hintText: 'Posizione attuale',
                scale: scale,
                colors: colors,
              ),
            ),

            // =========================
            // SEPARATORE + SCAMBIO DA/A
            // =========================
            // Per abbassare linea e switch, modifica il valore 5.
            // Esempio: 3 = meno basso, 7 = più basso.
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

                  // Bottone per invertire partenza e destinazione.
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
            ),

            // =========================
            // CAMPO DESTINAZIONE - A
            // =========================
            _SearchTextField(
              label: 'A',
              controller: _toController,
              icon: Icons.place_rounded,
              hintText: 'Dove vuoi andare?',
              scale: scale,
              colors: colors,
            ),

            SizedBox(height: 12 * scale),

            // =========================
            // BOTTONE CERCA PERCORSO
            // =========================
            SizedBox(
              width: double.infinity,
              height: 50 * scale,
              child: FilledButton.icon(
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
    required this.label,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.scale,
    required this.colors,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final double scale;

  // Usa la stessa palette della RouteSearchCard.
  final RouteSearchCardColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // =========================
        // ICONA LATERALE
        // =========================
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

        // =========================
        // TESTO LABEL + INPUT
        // =========================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Etichetta piccola: Da / A.
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.labelColor,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Campo testuale.
              TextField(
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
