import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/route_results_colors.dart';
import '../view_model/route_results_view_model.dart';
import 'primary_route_card.dart';
import 'route_navigation_button.dart';
import 'route_results_header.dart';

/// Mostra il risultato di percorso.
class RouteResultsScreen extends StatelessWidget {
  const RouteResultsScreen({super.key});

  void _showFeatureNotReadyMessage(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Navigazione percorso non ancora implementata.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RouteResultsViewModel>();

    return Scaffold(
      backgroundColor: RouteResultsColors.backgroundColor,
      body: viewModel.result == null
          ? const SizedBox.shrink()
          : _buildLoadedView(context, viewModel),
    );
  }

  Widget _buildLoadedView(
    BuildContext context,
    RouteResultsViewModel viewModel,
  ) {
    return Column(
      children: [
        RouteResultsHeader(
          result: viewModel.result!,
          onBack: () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              PrimaryRouteCard(
                departureDescription: viewModel.departureDescription,
                boardingStopDescription: viewModel.boardingStopDescription,
                recommendedLineDescription:
                    viewModel.recommendedLineDescription,
                durationDescription: viewModel.durationDescription,
                arrivalDescription: viewModel.arrivalDescription,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: RouteNavigationButton(
              onPressed: () => _showFeatureNotReadyMessage(context),
            ),
          ),
        ),
      ],
    );
  }
}
