# Configuration

Each query or infinite query can be configured using the QueryConfig.

```dart
final config = QueryConfig(
  storageSerializer: null,
  storageDeserializer: null,
  ignoreCacheDuration: false,
  storeQuery: true,
  staleDuration: Duration(seconds: 4),
  cacheDuration: Duration(minutes: 5),
  shouldRethrow: false,
  shouldRefetch: null,
);
```

### Stale Duration

The `staleDuration`, which defaults to 4 seconds is the amount of time after a request and before the data is marked
as stale. So if a query is requested twice in 4 seconds there will be no call made to the queryFn, however, if a request
is made after 4 seconds the data will be assumed to be stale and re-fetched.

### Cache Duration

The `cacheDuration` is the length of time between the last listener being removed from a query and the query being deleted
from the cache. The time can be ignored completely using `ignoreCacheDuration`, however using this would mean the query
is never removed from memory.

### Serialization

The `storageSerializer` and `storageDeserializer` are used to transform the data to and from the storage interface.
If you are using [Cached Storage](https://pub.dev/packages/cached_storage) then the data is always stored as json, so you would use the
storageSerializer to turn it back to the required object. Individually choose to store a query or not with `storeQuery.`

### Should Rethrow

By default, a query catches any error and emits it as part of the query state. However, in development it is sometimes
useful to have the query rethrow to quickly see the full stacktrace in the console, to do this set `shouldRethrow` to
true.

### Should fetch

Should fetch callback is rarely necessary but it can offer more flexibility on when a query should be fetched.
By default the should fetch callback is null, this is the recommended setting and in most cases you will not need to
use it.

```dart
QueryConfig(
    // This will prevent any fetch from happening.
    shouldFetch: (key, data, createdAt) => false,
);
```

### Polling / Refetch Duration

A query can be set to automatically refetch at a given interval using the `pollingDuration` parameter.
This is a function that will be called every time the query status changes. If a non-null duration is returned then the query will
automatically refetch at that interval.

By default the polling only affects active queries, meaning queries with listeners. However, this can be changed using the `pollInactive`
parameter.

```dart
QueryConfig(
  staleDuration: Duration.zero,
  pollInactive: true,
  pollingInterval: (state) {
    if (state.isError) {
      return null;
    }
    return const Duration(milliseconds: 5000);
  },
)
```

## Global Configuration

Global configuration can be set when instantiating a Cache or once by configuring the global instance.

```dart
CachedQuery.instance.config(
  config: GlobalQueryConfig(
    refetchDuration: Duration(seconds: 10),
    cacheDuration: Duration(minutes: 2),
  ),
);
```
