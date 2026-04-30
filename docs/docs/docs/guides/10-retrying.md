---
title: Retrying
---

# Retrying Failed Queries

By default, queries do not retry on failure. Add a `RetryConfig` to enable retries.

```dart
Query(
  key: 'posts',
  queryFn: () => api.getPosts(),
  config: QueryConfig(
    retryConfig: RetryConfig(
      maxRetries: 3,
    ),
  ),
);
```

This retries up to 3 times using exponential backoff (200ms, 400ms, 800ms) before emitting a `QueryError`.

## RetryConfig Options

### `maxRetries`

The number of retry attempts after the initial failure. Required.

### `delay`

A function that returns the delay before each retry. `attempt` is 1-indexed.

```dart
RetryConfig(
  maxRetries: 3,
  delay: (attempt) => Duration(seconds: attempt), // 1s, 2s, 3s
)
```

If omitted, exponential backoff is used: `200ms * 2^(attempt-1)`.

### `whenError`

A predicate to control which errors trigger a retry. Supports async.

```dart
RetryConfig(
  maxRetries: 3,
  whenError: (error, attempt) => error is NetworkException,
)
```

If omitted, all errors are retried.

## Retry State

`QueryLoading` and `InfiniteQueryLoading` expose a `retryCount` field. Use it to show retry feedback in the UI.

```dart
StreamBuilder(
  stream: query.stream,
  builder: (context, snapshot) {
    final state = snapshot.data;
    if (state is QueryLoading && state.isRetrying) {
      return Text('Retrying... (attempt ${state.retryCount})');
    }
    // ...
  },
);
```

## Global Default

Set a default retry policy for all queries via `GlobalQueryConfig`.

```dart
CachedQuery.instance.config(
  config: GlobalQueryConfig(
    retryConfig: RetryConfig(
      maxRetries: 3,
      whenError: (error, attempt) => error is NetworkException,
    ),
  ),
);
```

Per-query `retryConfig` overrides the global setting entirely.
