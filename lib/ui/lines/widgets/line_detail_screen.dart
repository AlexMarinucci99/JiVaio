import 'package:flutter/material.dart';

class LineDetailScreen extends StatelessWidget {
  const LineDetailScreen({
    super.key,
    required this.lineName,
  });

  final String lineName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Evitiamo il bottone automatico a sinistra.
        automaticallyImplyLeading: true,

        title: Text(lineName),

        // Bottone in alto a destra per tornare alla schermata elenco linee.
        actions: [
          IconButton(
            tooltip: 'Torna alle linee',
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),

      // Per ora schermata vuota.
      body: const SizedBox.expand(),
    );
  }
}