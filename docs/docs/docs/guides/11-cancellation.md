---
title: Cancellation
---

# Cancelling In-Flight Queries

Queries and infinite queries support manual cancellation of an in-flight fetch. The `queryFn` signature is unchanged — cancellation is opt-in. While a fetch is running, read the active token from `CachedQuery.instance.currentCancelToken` and wire it into your HTTP client or cooperative cancellation points.

When a fetch is cancelled, the query **reverts to its exact previous public state**. If it was in an error state before the fetch started, it returns to that error state rather than entering a new one. Cancellation is never surfaced as a new error and does not trigger retries.

## Manual cancellation

Cancel a single query or infinite query:

```dart
query.cancel('user navigated away');
infiniteQuery.cancel('user navigated away');
```

Cancel by cache key (works for both `Query` and `InfiniteQuery`):

```dart
CachedQuery.instance.cancelQueries(
  key: 'posts',
  reason: 'user navigated away',
);
```

Calling `cancel` when nothing is in flight is a no-op.

## Reading the cancel token

Inside any `queryFn`, the active cancel token is available via the zone-ambient accessor:

```dart
Query<Post>(
  key: 'post',
  queryFn: () async {
    final token = CachedQuery.instance.currentCancelToken;
    token?.throwIfCancelled();
    return fetchPost();
  },
);
```

For infinite queries, read the token inside the page function:

```dart
InfiniteQuery<List<Post>, int>(
  key: 'posts',
  getNextArg: (state) => (state?.pages.length ?? 0) + 1,
  queryFn: (page) async {
    final token = CachedQuery.instance.currentCancelToken;
    token?.throwIfCancelled();
    return fetchPosts(page);
  },
);
```

`currentCancelToken` returns `null` outside of a running `queryFn`, so `?.whenCancelled` and `?.throwIfCancelled()` are the natural idioms.

## Wiring into HTTP clients

A cancel token is only a **signal** — completing it does not by itself stop a Dart `Future`. To abort a real network request, pass the token into a client that supports cancellation.

### package:http (>= 1.5.0)

Use `whenCancelled` as the `abortTrigger` on an `AbortableRequest`. This requires `Client.send`, not the top-level `http.get` helper:

```dart
queryFn: () async {
  final token = CachedQuery.instance.currentCancelToken;
  final response = await client.send(
    AbortableRequest(
      'GET',
      uri,
      abortTrigger: token?.whenCancelled,
    ),
  );
  return parsePost(response);
},
```

When aborted, `http` throws `RequestAbortedException`. cached_query treats any in-flight fetch as cancelled when the token has been signalled, regardless of the exception type.

### package:dio

Bridge cached_query's token to dio's `CancelToken`:

```dart
queryFn: () async {
  final cqToken = CachedQuery.instance.currentCancelToken;
  final dioToken = dio.CancelToken();
  cqToken?.whenCancelled.then((_) => dioToken.cancel(cqToken.reason));
  final response = await dio.get(url, cancelToken: dioToken);
  return parsePost(response.data);
},
```

## Cooperative cancellation

For pure-Dart work that does not go through an abortable HTTP client, call `throwIfCancelled()` on the token between steps:

```dart
queryFn: () async {
  final token = CachedQuery.instance.currentCancelToken;
  for (final chunk in largeDataset) {
    token?.throwIfCancelled();
    await process(chunk);
  }
  return result;
},
```

This throws `QueryCancelledException`, which cached_query handles the same as an HTTP abort.

## Infinite query behaviour

Cancellation applies to all fetch paths that share the query controller:

- Initial fetch and `fetch()`
- `refetch()` and cache invalidation refetches
- `getNextPage()` and `getPreviousPage()`

During a multi-page refetch, cached_query checks the token between each page. Cancelling mid-refetch reverts to the state before the refetch started — partial page results are not applied.

## State after cancellation

| Before fetch | After cancel |
| --- | --- |
| `QuerySuccess` / `InfiniteQuerySuccess` | Same data and timestamp |
| `QueryError` / `InfiniteQueryError` | Same error, stack trace, and data |
| `QueryInitial` / `InfiniteQueryInitial` | Same initial state |

The query does not enter an error state or trigger [retries](/docs/guides/retrying) when cancelled.

## Edge cases

**Non-cooperative queryFn** — If the `queryFn` ignores the token, the underlying request may still complete. cached_query discards the result if cancellation was requested before the fetch settles.

**Concurrent fetches on the same key** — Duplicate fetches share one in-flight request and one cancel token. A manual cancel aborts the shared fetch for all listeners.

**Zone boundaries** — The token is propagated via Dart zones and survives `await` within the same isolate. It does not cross into spawned isolates.

**Mutations** — Mutations do not support cancellation in this release.
