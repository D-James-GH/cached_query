import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'testers/query_tester.dart';

void main() {
  group('ConnectionController', () {
    late StreamController<ConnectionStatus> connectionController;
    late CachedQuery cache;

    setUp(() {
      connectionController = StreamController<ConnectionStatus>.broadcast();
      cache = CachedQuery.asNewInstance()
        ..config(connectionStream: connectionController.stream);
    });

    tearDown(() async {
      await connectionController.close();
      cache.deleteCache();
    });

    test(
        'refetches queries with listeners when connection changes to connected',
        () async {
      final tester = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      // Add listener and fetch initially
      final subscription = tester.query.stream.listen((_) {});
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Simulate connection change from disconnected to connected
      connectionController
        ..add(ConnectionStatus.disconnected)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      expect(tester.numFetches, 2);

      await subscription.cancel();
    });

    test(
        'does not refetch queries without listeners when connection changes to connected',
        () async {
      final tester = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      // Fetch initially but don't add listener
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Simulate connection change from disconnected to connected
      connectionController
        ..add(ConnectionStatus.disconnected)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      // Should not refetch
      expect(tester.numFetches, 1);
    });

    test(
        'does not refetch queries with refetchOnConnection=false when connection changes',
        () async {
      final tester = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: false,
          staleDuration: Duration.zero,
        ),
      );

      // Add listener and fetch initially
      final subscription = tester.query.stream.listen((_) {});
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Simulate connection change from disconnected to connected
      connectionController
        ..add(ConnectionStatus.disconnected)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      // Should not refetch
      expect(tester.numFetches, 1);

      await subscription.cancel();
    });

    test('does not refetch when connection state does not change', () async {
      final tester = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      // Add listener and fetch initially
      final subscription = tester.query.stream.listen((_) {});
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Establish initial connected state
      connectionController.add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);
      expect(tester.numFetches, 2);

      // Send the same state multiple times - should not cause additional refetches
      connectionController
        ..add(ConnectionStatus.connected)
        ..add(ConnectionStatus.connected)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      // Should still be 2 (no additional refetches)
      expect(tester.numFetches, 2);

      await subscription.cancel();
    });

    test('does not refetch when changing from connected to disconnected',
        () async {
      final tester = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      // Add listener and fetch initially
      final subscription = tester.query.stream.listen((_) {});
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Establish connected state first (this will trigger a refetch)
      connectionController.add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);
      expect(tester.numFetches, 2);

      // Now change to disconnected - should not refetch
      connectionController.add(ConnectionStatus.disconnected);
      await Future<void>.delayed(Duration.zero);

      // Should still be 2 (no additional refetch)
      expect(tester.numFetches, 2);

      await subscription.cancel();
    });

    test('refetches from unknown to connected', () async {
      final tester = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      // Add listener and fetch initially
      final subscription = tester.query.stream.listen((_) {});
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Simulate connection change from unknown to connected
      connectionController
        ..add(ConnectionStatus.unknown)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      expect(tester.numFetches, 2);

      await subscription.cancel();
    });

    test('refetches multiple queries with listeners', () async {
      final tester1 = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      final tester2 = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      final tester3 = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: false,
          staleDuration: Duration.zero,
        ),
      );

      // Add listeners and fetch initially
      final subscription1 = tester1.query.stream.listen((_) {});
      final subscription2 = tester2.query.stream.listen((_) {});
      final subscription3 = tester3.query.stream.listen((_) {});

      await Future.wait([
        tester1.query.fetch(),
        tester2.query.fetch(),
        tester3.query.fetch(),
      ]);

      expect(tester1.numFetches, 1);
      expect(tester2.numFetches, 1);
      expect(tester3.numFetches, 1);

      // Simulate connection change from disconnected to connected
      connectionController
        ..add(ConnectionStatus.disconnected)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      // Only tester1 and tester2 should refetch
      expect(tester1.numFetches, 2);
      expect(tester2.numFetches, 2);
      expect(tester3.numFetches, 1);

      await subscription1.cancel();
      await subscription2.cancel();
      await subscription3.cancel();
    });

    test('works with infinite queries', () async {
      final tester = QueryTester.infinite(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      // Add listener and fetch initially
      final subscription = tester.query.stream.listen((_) {});
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Simulate connection change from disconnected to connected
      connectionController
        ..add(ConnectionStatus.disconnected)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      expect(tester.numFetches, 2);

      await subscription.cancel();
    });

    test('listener removed after initial fetch does not cause refetch',
        () async {
      final tester = QueryTester(
        cache: cache,
        config: const QueryConfig(
          refetchOnConnection: true,
          staleDuration: Duration.zero,
        ),
      );

      // Add listener and fetch initially
      final subscription = tester.query.stream.listen((_) {});
      await tester.query.fetch();
      expect(tester.numFetches, 1);

      // Cancel listener
      await subscription.cancel();

      // Simulate connection change from disconnected to connected
      connectionController
        ..add(ConnectionStatus.disconnected)
        ..add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      // Should not refetch because listener was removed
      expect(tester.numFetches, 1);
    });
  });

  group('ConnectionStatus', () {
    test('isConnected returns true only for connected state', () {
      expect(ConnectionStatus.connected.isConnected, true);
      expect(ConnectionStatus.disconnected.isConnected, false);
      expect(ConnectionStatus.unknown.isConnected, false);
    });
  });
}
