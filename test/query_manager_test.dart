import 'dart:convert';

import 'package:cached_query/src/query_manager.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late QueryManager<String> queryManager;
  setUp(() {
    queryManager = QueryManager(
      queryFn: () async => "test query",
      key: 'testKey',
      cacheTime: const Duration(seconds: 30),
      queryHash: jsonEncode('testKey'),
    );
  });

  group("Subscribe and unsubscribe", () {
    test("subscribe", () {
      final subscriber = Subscriber();
      queryManager.subscribe(subscriber);
      expect(queryManager.subscribers.length, 1);
      expect(queryManager.subscribers, contains(subscriber));
    });
    test("unsubscribe and gc", () {
      final subscriber = Subscriber();
      final secondSubscriber = Subscriber();
      queryManager.subscribe(subscriber);
      final secondUnsubscribe = queryManager.subscribe(secondSubscriber);
      expect(queryManager.subscribers.length, 2);
      // unsubscribe
      queryManager.unsubscribe(subscriber);
      expect(queryManager.subscribers, isNot(contains(subscriber)));

      secondUnsubscribe();
      expect(queryManager.subscribers, isNot(contains(secondSubscriber)));
      expect(queryManager.gcTimer, isNot(null));

      queryManager.subscribe(Subscriber());
      expect(queryManager.gcTimer?.isActive, false);
    });
  });
}
