import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/query/_query.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

void main() {
  test(
    "QueryController dispose cleans up timers correctly",
    () {
      fakeAsync((async) {
        final cache = CachedQuery.asNewInstance();
        final controller = QueryController<String>(
          key: "dispose",
          unencodedKey: "dispose",
          onFetch: QueryFetchFunction(queryFn: () async => "data"),
          initialData: null,
          config: QueryConfig(cacheDuration: const Duration(seconds: 5)),
          cache: cache,
        );

        final query = Query<String>.build(
          controller,
          QueryConfig(),
        );

        expect(controller.hasListeners, isFalse);

        controller.registerQuery(query);

        expect(controller.hasListeners, isTrue);

        controller.removeRegisteredQuery(query);

        expect(async.pendingTimers.length, 1);

        controller.dispose();

        expect(async.pendingTimers.length, 0);
      });
    },
  );
}
