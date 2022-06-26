# Cached Query Flutter
A set of useful widgets and additions to Cached Query for use with flutter. 
For more information visit [Cached Query](https://pub.dev/packages/cached_query).

## Features

* Refetch queries when connection is re-established.
* Refetch queries when the app comes back into the foreground.
* Builders for Query's, InfiniteQuery's and Mutations.


## Getting started

Configure the CachedQuery with `configFlutter` instead of `config`. This has two additional options; `refetchOnResume` 
and `refetchOnConnection`.

```dart
CachedQuery.instance.configFlutter(
    refetchOnResume: true,
    refetchOnConnection: true,
    storage: await CachedStorage.ensureInitialized(),
    config: const QueryConfig(),
);
```

The *refetchOnResume* option re-fetches any query or infinite query that has listeners when the app resumes. 

The *refetchOnConnection* option uses the connectivity package to detect when the device connection status changes, it 
then pings example.com to confirm the connection. If the device has connection after the check, all current queries are 
re-fetched.

## Usage

There are three builders that come with this package. Each of them is essentially a stream builder configured specifically 
for Cached Query.

## QueryBuilder

Query builder rebuilds the builder whenever the state of the query changes.

```dart
QueryBuilder<JokeModel?>(
    query: service.getJoke(),
    builder: (context, state) {
        if (state.status == QueryStatus.loading) {
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            );
        }
        return Text(state.data?.joke ?? "");
    },
);
```

## InfiniteQueryBuilder

Infinite query builder calls the builder function whenever the state of the infinite query changes. In addition to the 
current state and build context, InfiniteQueryBuilder also passes the InfiniteQuery object as well. This means you can 
call `getNextPage` from within the builder function.

```dart
InfiniteQueryBuilder<List<PostModel>, int>(
    query: query,
    builder: (context, state, query) {
      return Widget();
    },
)
```

Full example of using a custom scroll view with the infinite query to create an infinite list can be found 
[here](https://github.com/D-James-GH/cached_query/tree/main/examples/query_builder). 

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

## Additional information

This package is an addon for [Cached Query](https://pub.dev/packages/cached_query). For persistent storage take a look at
[Cached Storage].
