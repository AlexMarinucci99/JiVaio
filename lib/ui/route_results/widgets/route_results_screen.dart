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

  static const RouteResultsColors _colors = RouteResultsColors();

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
    return Consumer<RouteResultsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: _colors.backgroundColor,
          body: _buildBody(context, viewModel),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, RouteResultsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const _LoadingRouteResultsView(colors: _colors);
    }

    final result = viewModel.result;
    if (viewModel.errorMessage != null || result == null) {
      return _ErrorRouteResultsView(
        colors: _colors,
        message: viewModel.errorMessage ?? 'Nessun percorso disponibile.',
        onBack: () => Navigator.of(context).pop(),
        onRetry: viewModel.loadRoute,
      );
    }

    return _LoadedRouteResultsView(
      viewModel: viewModel,
      colors: _colors,
      onBack: () => Navigator.of(context).pop(),
      onStartNavigation: () => _showFeatureNotReadyMessage(context),
    );
  }
}

class _LoadedRouteResultsView extends StatelessWidget {
  const _LoadedRouteResultsView({
    required this.viewModel,
    required this.colors,
    required this.onBack,
    required this.onStartNavigation,
  });

  final RouteResultsViewModel viewModel;
  final RouteResultsColors colors;
  final VoidCallback onBack;
  final VoidCallback onStartNavigation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RouteResultsHeader(
          result: viewModel.result!,
          colors: colors,
          onBack: onBack,
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
                colors: colors,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: RouteNavigationButton(
              colors: colors,
              onPressed: onStartNavigation,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingRouteResultsView extends StatelessWidget {
  const _LoadingRouteResultsView({required this.colors});

  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          spacing: 18,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colors.accentColor),
            Text(
              'Caricamento percorso...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colors.textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorRouteResultsView extends StatelessWidget {
  const _ErrorRouteResultsView({
    required this.colors,
    required this.message,
    required this.onBack,
    required this.onRetry,
  });

  final RouteResultsColors colors;
  final String message;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: colors.surfaceColor,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: onBack,
                  tooltip: 'Torna indietro',
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: colors.textPrimaryColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Icon(Icons.route_rounded, size: 52, color: colors.accentColor),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.textPrimaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'La schermata è predisposta, ma i dati reali del percorso saranno collegati in una fase successiva.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondaryColor,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: colors.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Riprova'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
