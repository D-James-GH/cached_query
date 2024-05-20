import 'dart:io';

import 'package:cached_query_flutter/src/connectivity_controller.dart';
import 'package:cached_query_flutter/src/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'connectivity_controller_test.mocks.dart';

@GenerateMocks([Connectivity, ConnectivityService])
void main() {
  group("Check connection", () {
    final connectivity = MockConnectivity();
    final connectivityService = MockConnectivityService();

    test("If has a connection should return true", () async {
      when(connectivityService.lookup()).thenAnswer((_) async => true);
      final connectivityController = ConnectivityController.asNewInstance(
        connectivity: connectivity,
        service: connectivityService,
      );
      final hasConnection = await connectivityController.checkConnection();
      expect(hasConnection, true);
    });

    test("If no connection return false", () async {
      when(connectivityService.lookup()).thenAnswer((_) async => false);

      final connectivityController = ConnectivityController.asNewInstance(
        connectivity: connectivity,
        service: connectivityService,
      );
      final hasConnection = await connectivityController.checkConnection();
      expect(hasConnection, false);
    });
    test("Errors indicate no connection", () async {
      when(connectivityService.lookup())
          .thenThrow(const SocketException("could not find address."));

      final connectivityController = ConnectivityController.asNewInstance(
        connectivity: connectivity,
        service: connectivityService,
      );
      final hasConnection = await connectivityController.checkConnection();
      expect(hasConnection, false);
    });
    test("Should refetch queries when connectivity is resumed", () async {
      when(connectivity.onConnectivityChanged).thenAnswer(
        (_) => Stream.fromIterable(
          [
            [ConnectivityResult.wifi],
          ],
        ),
      );
      int callCount = 0;

      void refetch() {
        callCount++;
      }

      when(connectivityService.lookup()).thenAnswer((_) async => true);

      final controller = ConnectivityController.asNewInstance(
        connectivity: connectivity,
        service: connectivityService,
        initialConnection: false,
        refetchCurrentQueries: refetch,
      );
      await controller.initialize();
      expect(callCount, 1);
    });
  });
}
