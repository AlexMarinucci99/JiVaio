import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/route_results_colors.dart';
import '../view_model/route_results_view_model.dart';
import 'primary_route_card.dart';
import 'route_navigation_button.dart';
import 'route_results_header.dart';

/// Mostra il risultato di percorso esposto dal ViewModel scoped alla route.
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
    body: _buildBody(context, viewModel),
  );
}

Widget _buildBody(BuildContext context, RouteResultsViewModel viewModel) {
  if (viewModel.isLoading) {
    return _buildLoadingView(context);
  }

  return _buildLoadedView(context, viewModel);
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

  Widget _buildLoadingView(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          spacing: 18,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: RouteResultsColors.accentColor),
            Text(
              'Caricamento percorso...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: RouteResultsColors.textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
