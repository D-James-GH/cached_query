# Flutter Additions
If you are using flutter there are a couple of useful additions added.

To globally configure Cached Query Flutter use `CachedQuery.configFlutter` instead of `config`.
```dart
CachedQuery.instance.configFlutter(
  storage: await CachedStorage.ensureInitialized(),
  config: const QueryConfig(),
);
```

## Connection Monitoring 
Cached query flutter uses the [Connectivity Plus](https://pub.dev/packages/connectivity_plus) to monitor the connection 
status. If the connection changes from no-connection to valid connection Cached Query will ping example.com to verify the 
connection status. Any Query or Infinite Query that has listeners will be considered "active". Any active queries will be 
re-fetched if the connection is restored. Use the config to turn this off. 
```dart
CachedQuery.instance.configFlutter(
  refetchOnConnection: false,
);
```
## Refetch On Resume
Cached Query Flutter uses the `WidgetsBindingObserver` to monitor the lifecycle state of the app. If the app state is 
resumed any active queries will be re-fetched. Turn this off with the global flutter config.

```dart
CachedQuery.instance.configFlutter(
  refetchOnConnection: false,
  refetchOnResume: false,
);
```
## Builders
Three builders are added for ease of use. They act very similar to a `StreamBuilder`. 

### QueryBuilder
QueryBuilder takes a query and will call the builder method whenever the query state changes.

```dart
 QueryBuilder<DataModel?>(
  query: Query(
    key: "a query key",
    queryFn: () async => _api.getData(),
  ),
  builder: (context, state) {
    return Column(
      children: [
        if(state.status == QuerStatus.loading)
          const CircularProgressIndicator(),
        const DisplayData(data: state.data)
      ],
    );
  },
),
```

If you know that a query has already been instantiated then you can pass a key to the Query Builder instead, however this will fail if there is no query in the cache with that key.

```dart
 QueryBuilder<DataModel?>(
  queryKey: "a query key",
  builder: (context, state) {
    return Column(
      children: [
        if(state.status == QuerStatus.loading)
          const CircularProgressIndicator(),
        const DisplayData(data: state.data)
      ],
    );
  },
),
```

### InfiniteQueryBuilder
InfiniteQueryBuilder takes an infinite query and will call the builder method whenever the query state changes.

```dart
 InfiniteQueryBuilder<DataModel?>(
  query: InfiniteQuery(
    key: "a query key",
    queryFn: () async => _api.getData(),
    getNextArg: (state) {
      if (state.lastPage?.isEmpty ?? false) return null;
      return state.length + 1;
    },
  ),
  builder: (context, state) {
    if(state.data == null) return SizedBox();
    final allPosts = state.data!.expand((e) => e).toList();
    
    return CustomScrollView(
      slivers: [
        if (state.status == QueryStatus.error &&
            state.error is SocketException)
          SliverToBoxAdapter(
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Theme.of(context).errorColor),
              child: const Text(
                "No internet connection",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _Post(
              post: allPosts[i],
              index: i,
            ),
            childCount: allPosts.length,
          ),
        ),
        if (state.status == QueryStatus.loading)
          const SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
        )
      ],
    );
  },
)
```

Similar to the query builder you can also pass a key to the `InfiniteQueryBuilder` if you know there is a query available.

```dart
 InfiniteQueryBuilder<DataModel?>(
  query: InfiniteQuery(
    key: "a query key",
    queryFn: () async => _api.getData(),
    getNextArg: (state) {
      if (state.lastPage?.isEmpty ?? false) return null;
      return state.length + 1;
    },
  ),
  builder: (context, state) {
    //...build ui
  },
)
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

