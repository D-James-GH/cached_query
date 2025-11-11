import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/src/connectivity_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

class TestConnectivity implements Connectivity {
  TestConnectivity({
    List<ConnectivityResult>? initialResult,
  }) : _initialResult = initialResult ?? [ConnectivityResult.wifi];

  final StreamController<List<ConnectivityResult>> _controller =
      StreamController<List<ConnectivityResult>>.broadcast();
  final List<ConnectivityResult> _initialResult;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _controller.stream;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return _initialResult;
  }

  void emitConnectivityChange(List<ConnectivityResult> result) {
    _controller.add(result);
  }

  void close() {
    _controller.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectivityController', () {
    late TestConnectivity testConnectivity;
    late ConnectivityController controller;

    setUp(() {
      testConnectivity = TestConnectivity();
    });

    tearDown(() {
      controller.dispose();
      testConnectivity.close();
    });

    test('initializes with unknown connection status by default', () {
      controller = ConnectivityController.asNewInstance(
        connectivity: testConnectivity,
      );

      expect(controller.connectionStatus, ConnectionStatus.unknown);
    });

    test('initializes with custom initial connection status', () {
      controller = ConnectivityController.asNewInstance(
        connectivity: testConnectivity,
        initialConnection: ConnectionStatus.connected,
      );

      expect(controller.connectionStatus, ConnectionStatus.connected);
    });

    test('stream emits current status when listener is added', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.connected,
        );

        ConnectionStatus? capturedStatus;
        controller.stream.listen((status) {
          capturedStatus = status;
        });

        async.flushMicrotasks();

        expect(capturedStatus, ConnectionStatus.connected);
      });
    });

    test(
      'checkConnection sets status to connected when lookup succeeds',
      () {
        fakeAsync((async) {
          controller = ConnectivityController.asNewInstance(
            connectivity: testConnectivity,
            lookupFunction: () async => true,
          );

          async.flushMicrotasks();

          controller.checkConnection();
          async.elapse(const Duration(milliseconds: 100));

          expect(controller.connectionStatus, ConnectionStatus.connected);
        });
      },
    );

    test('handles wifi connectivity change', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.disconnected,
          lookupFunction: () async => true,
        );

        final statusUpdates = <ConnectionStatus>[];
        controller.stream.listen(statusUpdates.add);

        async.flushMicrotasks();
        statusUpdates.clear();

        testConnectivity.emitConnectivityChange([ConnectivityResult.wifi]);

        async.elapse(const Duration(milliseconds: 100));

        expect(statusUpdates.last, ConnectionStatus.connected);
      });
    });

    test('handles mobile connectivity change', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.disconnected,
          lookupFunction: () async => true,
        );

        final statusUpdates = <ConnectionStatus>[];
        controller.stream.listen(statusUpdates.add);

        async.flushMicrotasks();
        statusUpdates.clear();

        testConnectivity.emitConnectivityChange([ConnectivityResult.mobile]);

        async.elapse(const Duration(milliseconds: 100));

        expect(statusUpdates.last, ConnectionStatus.connected);
      });
    });

    test('handles ethernet connectivity change', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.disconnected,
          lookupFunction: () async => true,
        );

        final statusUpdates = <ConnectionStatus>[];
        controller.stream.listen(statusUpdates.add);

        async.flushMicrotasks();
        statusUpdates.clear();

        testConnectivity.emitConnectivityChange([ConnectivityResult.ethernet]);

        async.elapse(const Duration(milliseconds: 100));

        expect(statusUpdates.last, ConnectionStatus.connected);
      });
    });

    test('handles vpn connectivity change', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.disconnected,
          lookupFunction: () async => true,
        );

        final statusUpdates = <ConnectionStatus>[];
        controller.stream.listen(statusUpdates.add);

        async.flushMicrotasks();
        statusUpdates.clear();

        testConnectivity.emitConnectivityChange([ConnectivityResult.vpn]);

        async.elapse(const Duration(milliseconds: 100));

        expect(statusUpdates.last, ConnectionStatus.connected);
      });
    });

    test('handles other connectivity change', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.disconnected,
          lookupFunction: () async => true,
        );

        final statusUpdates = <ConnectionStatus>[];
        controller.stream.listen(statusUpdates.add);

        async.flushMicrotasks();
        statusUpdates.clear();

        testConnectivity.emitConnectivityChange([ConnectivityResult.other]);

        async.elapse(const Duration(milliseconds: 100));

        expect(statusUpdates.last, ConnectionStatus.connected);
      });
    });

    test('sets status to disconnected when connectivity is none', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.unknown,
        );

        async.elapse(const Duration(milliseconds: 100));

        controller.stream.listen((_) {});

        async.flushMicrotasks();

        testConnectivity.emitConnectivityChange([ConnectivityResult.none]);

        async.elapse(const Duration(milliseconds: 50));

        expect(controller.connectionStatus, ConnectionStatus.disconnected);
      });
    });

    test('handles multiple connectivity results', () {
      fakeAsync((async) {
        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.disconnected,
          lookupFunction: () async => true,
        );

        final statusUpdates = <ConnectionStatus>[];
        controller.stream.listen(statusUpdates.add);

        async.flushMicrotasks();
        statusUpdates.clear();

        testConnectivity.emitConnectivityChange([
          ConnectivityResult.wifi,
          ConnectivityResult.mobile,
        ]);

        async.elapse(const Duration(milliseconds: 100));

        expect(statusUpdates.last, ConnectionStatus.connected);
      });
    });

    test('checkConnection prevents concurrent calls', () {
      fakeAsync((async) {
        int lookupCallCount = 0;

        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          lookupFunction: () async {
            lookupCallCount++;
            return true;
          },
        );

        async.elapse(const Duration(milliseconds: 100));

        lookupCallCount = 0;

        controller
          ..checkConnection()
          ..checkConnection()
          ..checkConnection();

        async.elapse(const Duration(milliseconds: 100));

        expect(controller.connectionStatus, ConnectionStatus.connected);
        expect(lookupCallCount, 1);
      });
    });

    test('constructor calls checkConnection immediately', () {
      fakeAsync((async) {
        final statusUpdates = <ConnectionStatus>[];

        controller = ConnectivityController.asNewInstance(
          connectivity: testConnectivity,
          initialConnection: ConnectionStatus.unknown,
          lookupFunction: () async => true,
        );

        controller.stream.listen(statusUpdates.add);

        async.elapse(const Duration(milliseconds: 100));

        expect(statusUpdates.isNotEmpty, true);
      });
    });
  });
}
