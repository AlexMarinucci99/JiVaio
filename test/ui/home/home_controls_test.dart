import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/data/repositories/location_repository.dart';
import 'package:jivaio/data/services/location_service.dart';
import 'package:jivaio/domain/models/location_access_result.dart';
import 'package:jivaio/domain/models/user_location.dart';
import 'package:jivaio/ui/home/view_model/home_map_view_model.dart';
import 'package:jivaio/ui/home/widgets/home_alert_dialog.dart';
import 'package:jivaio/ui/home/widgets/locate_user_button.dart';

import '../../helpers/transit_fakes.dart';

class _LocationService implements LocationService {
  final access = Completer<LocationAccessResult>();
  int accessRequests = 0;
  int positionRequests = 0;

  @override
  Future<LocationAccessResult> ensureLocationAccess() {
    accessRequests++;
    return access.future;
  }

  @override
  Future<UserLocation> getCurrentLocation() async {
    positionRequests++;
    return const UserLocation(latitude: 42.35, longitude: 13.4);
  }

  @override
  Future<bool> openLocationSettings() async => true;

  @override
  Future<bool> openAppPermissionSettings() async => true;
}

void main() {
  for (final result in [
    LocationAccessResult.granted,
    LocationAccessResult.permissionDenied,
  ]) {
    testWidgets('il pulsante GPS mostra attesa e si riabilita dopo $result', (
      tester,
    ) async {
      final service = _LocationService();
      final model = HomeMapViewModel(
        repository: FakeTransitRepository(),
        locationRepository: LocationRepository(service: service),
      );
      Future<LocationAccessResult>? request;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => model,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer<HomeMapViewModel>(
                builder: (_, state, _) => LocateUserButton(
                  isLoading: state.isLocating,
                  onPressed: () => request = state.locateUser(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(LocateUserButton));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.my_location_rounded), findsNothing);
      await tester.tap(find.byType(LocateUserButton));
      expect(service.accessRequests, 1);
      service.access.complete(result);
      expect(await request, result);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
      expect(
        service.positionRequests,
        result == LocationAccessResult.granted ? 1 : 0,
      );
      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNotNull);
    });
  }

  for (final confirm in [false, true]) {
    testWidgets(
      'dialogo GPS: ${confirm ? 'conferma invoca callback' : 'annulla senza callback'}',
      (tester) async {
        var confirmed = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showHomeAlertDialog(
                    context,
                    title: 'Permesso necessario',
                    message: 'Abilita la posizione',
                    dismissLabel: 'Annulla',
                    confirmLabel: 'Apri impostazioni',
                    onConfirm: () => confirmed++,
                  ),
                  child: const Text('Apri avviso'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Apri avviso'));
        await tester.pumpAndSettle();
        expect(find.text('Permesso necessario'), findsOneWidget);
        expect(find.text('Abilita la posizione'), findsOneWidget);
        await tester.tap(find.text(confirm ? 'Apri impostazioni' : 'Annulla'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(confirmed, confirm ? 1 : 0);
      },
    );
  }
}
