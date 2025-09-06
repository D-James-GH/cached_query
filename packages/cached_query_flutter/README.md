<h1 align="center"><a  href="https://cachedquery.dev">Cached Query Flutter</a></h1>

<p align="center">Visit the <a href="https://cachedquery.dev/">documentation</a> for more information.</p>

A set of useful widgets and additions to Cached Query for use with flutter.
For more information on how the caching works visit [Cached Query](https://pub.dev/packages/cached_query).

## Features

- Refetch queries when connection is re-established.
- Refetch queries when the app comes back into the foreground.
- Builders for Query's, InfiniteQuery's and Mutations.

## Getting started

Configure the CachedQuery with `configFlutter` instead of `config`.

```dart
CachedQuery.instance.configFlutter(
    config: GlobalQueryConfigFlutter(
        refetchOnConnection: true,
        refetchOnResume: true,
    ),
    storage: await CachedStorage.ensureInitialized(),
);
```

The _refetchOnResume_ option re-fetches any query or infinite query that has listeners when the app resumes.

The _refetchOnConnection_ option uses the connectivity package to detect when the device connection status changes, it
then pings example.com to confirm the connection. If the device has connection after the check, all current queries are
re-fetched.

Each of these options can be configured globally or in the query using `QueryConfigFlutter` as the config option.

## Usage

There are three builders that come with this package. Each of them is essentially a stream builder configured specifically
for Cached Query.

## QueryBuilder

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

## MutationBuilder

Much the same as the query builder. It will call the builder function when the mutation state changes.

```dart
 MutationBuilder<PostModel, PostModel>(
    mutation: _postService.createPost(),
    builder: (context, state, mutate) {
      // Can use the mutate() function directly in the builder.
    },
  ),
```

## With the bloc pattern

Cached query compliments the bloc pattern well. Manually caching server state in a bloc can get messy. This is why Cached
Query can work so well with blocs. By allowing Cached Query to handle the server state in the domain layer the blocs
should become cleaner.

The following examples are using the [flutter_bloc](https://pub.dev/packages/flutter_bloc) package
but the ideas should be transferable to any other state management library.

Full example with flutter_bloc [here](https://github.com/D-James-GH/cached_query/tree/main/examples/cached_query_bloc).

### Using the query directly in the UI.

One option to use cached query and flutter bloc together is to just hold in Query as a field on the state of the bloc.
The benefit of this is that you can still use all the query builders in the ui and Cached Query will accurately know which
queries are currently in use.

### Streaming from the domain layer

Another option is to create the query at the repository level then have bloc listen to changes in the query stream.
The benefit to the below is that it is much easier to drop into existing apps as you only need to make small changes to
the domain layer and the bloc layer, the ui can be left alone.

Here is the query:

```dart
Query<JokeModel?> getJoke() {
    return Query<JokeModel>(
      key: 'joke',
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
    );
}
```

We can use flutter_bloc's `Emmiter.forEach` handle subscriptions to the query and emit a bloc state change when ever the
state of the query changes.

```dart
FutureOr<void> _onJokeFetched(
    JokeFetched event,
    Emitter<JokeState> emit,
    ) {
  return emit.forEach<QueryStatus<JokeModel?>>(
    _repo.getJoke().stream,
    onData: (queryState) => state.copyWith(
      joke: queryState.data,
      status: queryState.isLoading
          ? JokeStatus.loading
          : JokeStatus.success,
    ),
  );
}
```

The bloc will automatically unsubscribe from the query when it is removed from the widget tree, then the query can start
its clean up process. For this reason it is recommended to scope blocs with queries to smaller features of your app.
This way cached query knows which queries are currently in use or not.

It is also a good idea to use the `restartable()` event transformer from [bloc_concurrency](https://pub.dev/packages/bloc_concurrency).

```dart
on<JokeFetched>(_onJokeFetched, transformer: restartable());
```

The `restartable` transformer only allows one of the JokeFetched events to be active at once. This means if JokeFetched
was called again it would cancel the current query stream and start a new one preventing an ever-increasing number of
listeners.

## Additional information

This package is an addon for [Cached Query](https://pub.dev/packages/cached_query). For persistent storage take a look at
[Cached Storage].
