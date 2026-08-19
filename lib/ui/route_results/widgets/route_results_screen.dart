import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/back_button.dart';
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
      builder: (context, viewModel, _) => Scaffold(
        backgroundColor: _colors.backgroundColor,
        body: _buildBody(context, viewModel),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RouteResultsViewModel viewModel) {
    if (viewModel.isLoading) {
      return _buildLoadingView(context);
    }

    final result = viewModel.result;
    if (viewModel.errorMessage != null || result == null) {
      return _buildErrorView(
        context,
        message: viewModel.errorMessage ?? 'Nessun percorso disponibile.',
        onRetry: viewModel.loadRoute,
      );
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
          colors: _colors,
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
                colors: _colors,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: RouteNavigationButton(
              colors: _colors,
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
            CircularProgressIndicator(color: _colors.accentColor),
            Text(
              'Caricamento percorso...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _colors.textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Spacer(),
            Icon(Icons.route_rounded, size: 52, color: _colors.accentColor),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: _colors.textPrimaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'La schermata è predisposta, ma i dati reali del percorso saranno collegati in una fase successiva.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: _colors.textSecondaryColor,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 6, 27, 59),
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
