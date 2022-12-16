# Configuration

Each query or infinite query can be configured using the QueryConfig.
```dart
final config = QueryConfig(
  refetchDuration: Duration(seconds: 4),
  cacheDuration: Duration(minutes: 5),
  ignoreCacheDuration: false,
  serializer: (dynamic data) {},
  shouldRethrow: false,
  storeQuery: false,
);
```
The `refetchDuration`, which defaults to 4 seconds is the amount of time after a request and before the data is marked 
as stale. So if a query is requested twice in 4 seconds there will be no call made to the queryFn, however, if a request
is made after 4 seconds the data will be assumed to be stale and re-fetched in the background.

The `cacheDuration` is the length of time between the last listener being removed from a query and the query being deleted
from the cache. The time can be ignored completely using `ignoreCacheDuration`, however using this would mean the query
is never removed from memory.

The `serializer` is used called the data for a query is retrieved from persistent storage. If you are using 
[Cached Storage](https://pub.dev/packages/cached_storage) then the data is always stored as json, so you would use the 
serializer to turn it back to the required object. Individually choose to store a query or not with `storeQuery.`

By default, a query catches any error and emits it as part of the query state. However, in development it is sometimes 
useful to have the query rethrow to quickly see the full stacktrace in the console, to do this set `shouldRethrow` to 
true.

:::caution
Using `shouldRethrow` can cause unexpected errors as it prevents most things from happening after an error has occurred.
:::

## Global Configuration

Global configuration allows defaults to be set for all queries. Using the `QueryConfig` on an individual query will 
always override the global default. To set global defaults pass a config to the cached query instance before any queries
are called.

```dart
CachedQuery.instance.config(
  config: QueryConfig(
    refetchDuration: Duration(seconds: 10),
    cacheDuration: Duration(minutes: 2),
  ),
);
```




