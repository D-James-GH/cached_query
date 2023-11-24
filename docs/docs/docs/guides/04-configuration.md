# Configuration

Each query or infinite query can be configured using the QueryConfig.
```dart
final config = QueryConfig(
  storageSerializer: null,
  storageDeserializer: null,
  ignoreCacheDuration: false,
  storeQuery: true,
  refetchDuration: Duration(seconds: 4),
  cacheDuration: Duration(minutes: 5),
  shouldRethrow: false,
  shouldRefetch: null,
);
```
### Refetch Duration
The `refetchDuration`, which defaults to 4 seconds is the amount of time after a request and before the data is marked 
as stale. So if a query is requested twice in 4 seconds there will be no call made to the queryFn, however, if a request
is made after 4 seconds the data will be assumed to be stale and re-fetched in the background.

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

:::caution
Using `shouldRethrow` can cause unexpected errors as it prevents most things from happening after an error has occurred.
:::

### Should Refetch
Should refetch callback is rarely necessary but it can offer more flexibility on when a query should be automatically re-fetched.
By default the should refetch callback is null, this is the recommended setting and in most cases you will not need to
use it.
```dart
QueryConfig(
  shouldRefetch: (query, fromStorage) => true,
);
```
It is before a query is automatically re-fetched and after any data is fetched from storage. It passes the query and a boolean to mark
if the data was fetched from storage. If the function returns false then the query will not be re-fetched.

This does not effect the Query.refetch method. 


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




