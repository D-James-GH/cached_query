# Flutter Additions

If you are using flutter there are a couple of useful additions added.

To globally configure Cached Query Flutter use `CachedQuery.configFlutter` instead of `config`.

```dart
CachedQuery.instance.configFlutter(
  storage: await CachedStorage.ensureInitialized(),
  config: GlobalQueryConfigFlutter(),
);
```

## Connection Monitoring

Cached query flutter uses the [Connectivity Plus](https://pub.dev/packages/connectivity_plus) to monitor the connection
status. If the connection changes from no-connection to valid connection Cached Query will ping example.com to verify the
connection status. Any Query or Infinite Query that has listeners will be considered "active". Any active queries will be
re-fetched if the connection is restored. Use the config to turn this off.

```dart
CachedQuery.instance.configFlutter(
  config: GlobalQueryConfigFlutter(
    refetchOnConnection: true,
  ),
);
```

This can be configured in the individual query.

```dart
Query(
  key: "a query key",
  queryFn: () async => _api.getData(),
  config: QueryConfigFlutter(
    refetchOnResume: false,
    refetchOnConnection: true,
  ),
),
```

## Refetch On Resume

Cached Query Flutter uses the `WidgetsBindingObserver` to monitor the lifecycle state of the app. If the app state is
resumed any active queries will be re-fetched. Turn this off with the global flutter config.

```dart
CachedQuery.instance.configFlutter(
  config: QueryConfigFlutter(
    refetchOnResume: false,
    refetchOnConnection: true,
  ),
);
```

This can be configured in the individual query.

```dart
Query(
  key: "a query key",
  queryFn: () async => _api.getData(),
  config: QueryConfigFlutter(
    refetchOnResume: false,
    refetchOnConnection: true,
  ),
),
```

## Builders

Three builders are added for ease of use. They act very similar to a `StreamBuilder`.

### Enabling and Disabling

By default, the builders will subscribe to the query's listener on `initState` and unsubscribe on `dispose`.
This means that the query will be fetched when the widget is first rendered. You can prevent this using the `enabled` flag
on the `InfiniteQueryBuilder` and `QueryBuilder`.

:::warning

This will only prevent the widget from adding a listener to the query. If you have other listeners elsewhere then the
query will still be fetched.

:::

### QueryBuilder

QueryBuilder takes a query or infinite query and will call the builder method whenever the query state changes.

```dart
/// For a query
 QueryBuilder<QueryStatus<JokeModel?>>(
  query: Query(
    key: "a query key",
    queryFn: () async => _api.getData(),
  ),
  builder: (context, state) {
    return Column(
      children: [
        if(state.isLoading)
          const CircularProgressIndicator(),
        const DisplayData(data: state.data)
      ],
    );
  },
),
/// For an infinite query
QueryBuilder<InfiniteQueryStatus<JokeModel?>>(
  query: InfiniteQuery(
    key: "a query key",
    getNextArg: (state) => state.length + 1,
    queryFn: () async => _api.getData(),
  ),
  builder: (context, state) {
    //... return widget
  },
),
```

If you know that a query has already been instantiated then you can pass a key to the Query Builder instead, however this will fail if there is no query in the cache with that key.

```dart
 QueryBuilder<QueryStatus<JokeModel>>(
  queryKey: "a query key",
  builder: (context, state) {
    return Column(
      children: [
        if(state.isLoading)
          const CircularProgressIndicator(),
        const DisplayData(data: state.data)
      ],
    );
  },
),
```

### MutationBuilder

Much the same as the query builder. It will call the builder function when the mutation state changes.

```dart
 MutationBuilder<PostModel, PostModel>(
    mutation: _postService.createPost(),
    builder: (context, state, mutate) {
      // Can use the mutate() function directly in the builder.
    },
  ),
```
