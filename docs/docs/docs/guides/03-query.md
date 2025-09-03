---
title: Query
---

# Automatic Caching with Query

A query is used to cache single asynchronous requests in a unified and consistent way. The simplest form of a query is
shown below. No global configuration is needed, although possible.

```dart
final query = Query(
  key: "my_data",
  initialData: "Pre-populated data",
  queryFn: () => api.getData(),
);
```

Each Query must have a `queryFn` and a key. The `queryFn` is an asynchronous function that can return any value which will then be cached.

## Query Key

A query must be given a unique key which can be any json serializable value. Each unique key will create a new query in
the cache. Initial data can be passed to the query. On the first request this initial data will be emitted as part of the state
rather than null.

Only one query will ever exist for each key. If a query is instantiated with a key that already exists the existing query will be returned.

A good query key is important to ensure data is not overridden. Include any parameters and variable in a query key:

```dart
String createPostKey(String id) => "post/$id";
```

### Query State

`QueryStatus` is the sealed class containing the current state of the query.

- `QueryInitial` - The query has been created but the queryFn has not been called yet.
- `QueryLoading` - The queryFn is currently running.
- `QuerySuccess` - The queryFn has completed successfully and data is available.
- `QueryError` - The queryFn has failed and an error is available.

The current data is available on all states. On the `QuerySuccess` state the data will be the exact type of the generic passed in. On all other states
data will be nullable as there is a chance the queryFn hasn't returned anything yet.

## Fetching Data

A query will not invoke the queryFn until one of two things is used:

1. The `fetch()` method is invoked
2. A listener is added to the query stream.

## Query Stream

Each query manages its own stream controller. Streams enable a query to display currently existing data while fetching
new data in the background. When the new data is ready it will be emitted. A query stream will also emit any time the
state of the query is changed, this is useful for [mutations](/docs/guides/mutations) and
[optimistic updates](/docs/guides/optimistic-updates).

```dart
final query = Query(key: "my_data", queryFn: () => api.getData());

query.stream((state) {
  if(state.status == QueryStatus.loading){
    // show loading spinner
  }
  if(state.data != null){
    // update ui to show the data.
  }
});
```

## Query Fetch

`Query.fetch()` is a quick and easy way to request the result of a queryFn. It returns [QueryState](#query-state) once
the queryFn has completed. For the full benefits of Cached Query use the stream api.

```dart
final query = Query(key: "my_data", queryFn: () => api.getData());

final queryState = await query.fetch();
```

There are a few downsides to using a query this way. The future always completes after the queryFn has completed. If the
data is stale then nothing will show until fresh data is available, meaning you are not getting the benefits of
background fetches.

As the Queries use streams to detect how many listeners they have left, using `Query.fetch` never adds a
listener to the query. So, when the future is requested the [cache duration](/docs/guides/configuration) timer is started
immediately if there are no other listeners attached.

## Error Handling

If a query, infinite query or a mutation throws an error or exception it will be caught and the current state will be
updated with the error.

## Side Effects

There are two side effects that can be passed to a query.

- `onSuccess` - This is called after the query function succeeds but before the query state is updated.
- `onError` - This is called if the query function fails but before the query state is updated.

```dart
final query = Query<String>(
  key: "onSuccess",
  onSuccess: (dynamic r) {
    // do something with the response
  },
  onError: (dynamic e){
    // do something with the error
  },
  queryFn: () async {
    //...queryFn
  },
);
```

## Local Cache

By default, all queries will be saved inside the `CachedQuery.instance` singleton. Most of the time this is enough.
However, it may be useful to have full control of the cache for different areas of an app to prevent leaking sensitive
information by not deleting the queries. Each query has a `cache` prop which allows you to pass in specific instance of `CachedQuery`.

```dart
final cache = CachedQuery.asNewInstance()
  ..configFlutter();

final query = Query(
  cache: cache,
  key: queryKey(id),
  queryFn: () async {
    final uri = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts/$id',
    );
    final res = await http.get(uri);
    return PostModel.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  },
);
```

A new instance of `CachedQuery` can have a different config to the global one.

If no cache is passed the query will be cached in the default `CachedQuery.instance` singleton.

A full example can be found here: https://github.com/D-James-GH/cached_query/tree/main/examples/multiple_caches
