import 'package:flutter/material.dart';

import '../../../data/repositories/route_planning_repository.dart';
import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';
import '../view_model/route_results_view_model.dart';
import 'primary_route_card.dart';
import 'route_navigation_button.dart';
import 'route_results_header.dart';

/// Schermata dei risultati della ricerca percorso.
///
/// Per ora mostra una sintesi dimostrativa basata sui dati mock
/// provenienti da [RoutePlanningRepository]. In futuro potrà integrare
/// timeline completa, alternative e navigazione assistita senza modificare
/// la struttura generale della feature.
class RouteResultsScreen extends StatefulWidget {
  const RouteResultsScreen({
    super.key,
    required this.repository,
    required this.origin,
    required this.destination,
  });

  /// Repository usato per ottenere il percorso da mostrare.
  final RoutePlanningRepository repository;

  final String origin;

  final String destination;

  @override
  State<RouteResultsScreen> createState() => _RouteResultsScreenState();
}

class _RouteResultsScreenState extends State<RouteResultsScreen> {
  late final RouteResultsViewModel _viewModel;
  final RouteResultsColors _colors = const RouteResultsColors();

  @override
  void initState() {
    super.initState();

    _viewModel = RouteResultsViewModel(
      repository: widget.repository,
      origin: widget.origin,
      destination: widget.destination,
    );

    _viewModel.loadRoute();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }

  void _showFeatureNotReadyMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _handleStartNavigation() {
    _showFeatureNotReadyMessage(
      'Navigazione percorso non ancora implementata.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final result = _viewModel.result;

        return Scaffold(
          backgroundColor: _colors.backgroundColor,
          body: _buildBody(result),
        );
      },
    );
  }

  Widget _buildBody(RouteResult? result) {
    if (_viewModel.isLoading) {
      return _LoadingRouteResultsView(colors: _colors);
    }

    final errorMessage = _viewModel.errorMessage;

    if (errorMessage != null) {
      return _ErrorRouteResultsView(
        colors: _colors,
        message: errorMessage,
        onBack: _handleBack,
        onRetry: _viewModel.loadRoute,
      );
    }

    if (result == null) {
      return _ErrorRouteResultsView(
        colors: _colors,
        message: 'Nessun percorso disponibile.',
        onBack: _handleBack,
        onRetry: _viewModel.loadRoute,
      );
    }

    return _LoadedRouteResultsView(
      result: result,
      colors: _colors,
      onBack: _handleBack,
      onStartNavigation: _handleStartNavigation,
    );
  }
}

class _LoadedRouteResultsView extends StatelessWidget {
  const _LoadedRouteResultsView({
    required this.result,
    required this.colors,
    required this.onBack,
    required this.onStartNavigation,
  });

  final RouteResult result;
  final RouteResultsColors colors;
  final VoidCallback onBack;
  final VoidCallback onStartNavigation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RouteResultsHeader(result: result, colors: colors, onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            children: [PrimaryRouteCard(result: result, colors: colors)],
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
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colors.accentColor),
            const SizedBox(height: 18),
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
