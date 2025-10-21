import 'package:cached_query/cached_query.dart';
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
          onFetch: ({required options, state}) async => "data",
          initialData: null,
          config: QueryConfig(cacheDuration: const Duration(seconds: 5)),
          cache: cache,
        );

        expect(controller.hasListener, isFalse);

        controller.addListener();

        expect(controller.hasListener, isTrue);

        controller.removeListener();

        expect(async.pendingTimers.length, 1);

        controller.dispose();

        expect(async.pendingTimers.length, 0);
      });
    },
  );
}
