# Cached Query
 
A small collection of dart and flutter libraries inspired by tools such as SWR, RTKQuery, React Query, Urql and apollo
from the React world.

Cache any the response of any asynchronous function (usually external api requests) for a fast and snappy user
experience. 

Accompanying packages:
* 📱 [Cached Query Flutter](https://pub.dev/packages/cached_query_flutter) - Useful flutter additions, including connectivity status. 
* 💽 [Cached Storage](https://pub.dev/packages/cached_storage) - an implementation of the `CachedQuery StorageInterface` using `sqflite`

## Contents

* [Features](#features)
* [Getting Started](#getting-started)
* [Config](#config)
* [Re-fetching and Invalidation](#re-fetching-and-invalidation)
* [Infinite Query](#infinitequery)
* [Mutations](#mutation)
  * [Optimistic Updates](#optimistic-updates)
  * [Updating Cached Data](#updating-the-query-cache)
* [Persisting Data](#persistent-storage)
* [Error Handling](#error-handling)
* [Additional Information](#additional-information)

## Features

* Cached responses
* Infinite list caching
* Background fetching
* Mutations
* Persistent cache (flutter ios/android only, or easily create your own)
* Can be used alongside state management options (Bloc, Provider, etc...)
* Refetch when connection is resumed (flutter only)
* Refetch when app comes into the foreground (flutter only)


## Getting started

All you need to do is wrap an asynchronous function in a Query, give it a key and await the result.
```dart
Future<SomeData?> getCachedData() async {
  final query = Query(key: "My key", queryFn: fetchData);
  final queryState = await query.result;
  return queryState.data;
}
```
CachedQuery will store the data returned from `fetchData` against the `key` so that the second time `getCachedData` 
is called it loads immediately.

The best way to use CachedQuery is to listen to the stream outputted by a query. This gives benefits like loading states, 
background fetches and better cache management.
```dart
Stream<QueryState<SomeData>> getCachedData() async {
  final query = Query(key: "My key", queryFn: fetchData);
  return query.stream;
}
```
Now anytime that query is fetched or mutated your UI can react to it.

## Config
A default config can be set once, so it is best to do this at the start of the app. 
```dart
void main() async {
  CachedQuery.instance.config(
    storage: ImpementsStorageInterface(),
    config: const QueryConfig(
      refetchDuration: Duration(seconds: 4),
      cacheDuration: Duration(minutes: 5),
    ),
  );
}
```

The QueryConfig can be overridden on any individual query. The `refetchDuration` sets the minimum time before the queryFn
is called again. The defaults to 4 seconds but if you know data is unlikely to get stale this could be increased. If you
are using the `Query.stream` api then the latest current cached data will always be emitted while waiting for data to be returned 
from the queryFn.

The `cacheDuration` is how long any data that has no listeners stays in cache. When using the `Future` api (query.result)
the query is never has any listeners so the `cacheDuration` immediately starts after new data is fetched. If you are using 
the `Stream` api then the `cacheDuration` timer will start when the last listener is removed.

## Re-fetching and Invalidation

Any Query will automatically be re-fetched if another call to the query function happens after the refetchDuration.
A Query can be forced to re-fetched at anytime using `Query.refetch()`.

After the `refetchDuration` is finished the query will be marked as stale. This is what causes a refetch the next time 
the query is requested. A query can be manually be invalidated with `Query.invalidate()` or a list of queries can be
invalidated at once with `CachedQuery.instance.invalidateCache`, this is useful during [Mutations](#mutation).

## InfiniteQuery

Use an `InfintiteQuery` to handle caching for an infinite list. The caching works in much the same way as a Query and 
actually extends the QueryBase.

Infinite query takes two generic arguments, the first being the data that will be returned from the `queryFn` and the 
second is the type of the argument that will be passed to the `queryFn`.

```dart
final postsQuery = InfiniteQuery<List<PostModel>, int>(
  key: 'posts',
  getNextArg: (state) {
    if (state.lastPage?.isEmpty ?? false) return null;
    return state.length + 1;
  },
  queryFn: (page) {
    return fetchPosts(endpoint: "/api/data?page=${page}");
  },
);
```

The function `getNextArg` will always be called before the query function. Whatever is returned from `getNextArg` will 
be passed to the `queryFn`. If the return value of `getNextArg` is null the state on the infinite query will be set to 
`hasReachedMax=true`. This will  block further page calls.

The cached data of an infinite query will always be a list of previously fetched pages. To fetch the next page use `
infiniteQuery.getNextPage()`. 

Re-fetching an infinite query re-fetches each page individually starting with the first page. This is to make sure every
 page is upto date and there are no duplicate entries.

## Mutation
By its self a mutation doesn't really do anything. However, it comes with a lot of useful options for updating previously 
fetched queries. The simplest is the `invalidateQueries` prop, which takes a list query keys to invalidate once the
mutation has succeeded. 
```dart
final createPostMutation = Mutation<PostModel, PostModel>(
  invalidateQueries: ['posts'],
  queryFn: (post) => createPost(post),
);
```

Start the mutation by calling mutation on the Mutation object. 

*Note: the mutate function is also a future that will complete when the mutation succeeds or errors.*
```dart
final createdPost = await createPostMutation.mutate(Post(title: "New post"));
```

If a key is given to a mutation it will be cached. This is useful if you need to listen to the state of the mutation 
anywhere in the app. For example, you could show a loading spinner in the app bar by creating a new mutation object with
 the same key and listening to the state stream.
```dart
Mutation<PostModel, PostModel> createPost(){
  return Mutation<PostModel, PostModel>(
    key: "createPost",
    queryFn: (post) => createPost(post),
  );
}

// In the app bar
createPost().stream.listen((state){});

// In the create post form
createPost().mutate(Post(title: "New post"));
```
Because the above mutation has a key the instance of Mutation returned from `createPost` will always be the same and 
therefore the state can be observed from anywhere.


### Optimistic updates

There are a few useful callbacks that enable optimistic updates. 

The order of execution is: `onStartMutation -> queryFn -> onSuccess`. `onError` is called if the mutation fails.  

```dart
Mutation<PostModel, PostModel>(
    key: "createPost",
    queryFn: (post) => createPost(post),
    onStartMutation: (post) {
      CachedQuery.instance.updateInfiniteQuery<List<PostModel>>(
        key: "posts",
        updateFn: (old) => [
          [newPost, ...old![0]],
          ...old.sublist(1).toList()
        ],
      );
    },
    onSuccess: (argument, returnedValue) {
      // Do something with the returned value. 
    },
);
```
### Updating the query cache.

 All the versions of updating a query require an update function. An update function passes through the current cached 
 data and must return the new data of the same type. 

 There are a few ways to update the query cache.
* If you know the key of the query you can use: `CachedQuery.instance.updateInfiniteQuery` or 
`CachedQuery.instance.updateQuery`. Using the key will get the query from cache and call the update function on it.
* If you have an instance of a query or infinite query, you can call update directly on it. 
`Query.update((current) => current + 1)`

`CachedQuery.instance.whereQuery((query) => true | false)` is a utility function that functions much like `List.where`. It iterates through the 
cache and returns all queries that satisfy the test function.

## Persistent Storage

Cached query can be configured with a persistent storage option. The package [**cached_storage**](Todo: add link) has 
built with **Sqflite** to cache queries to disk. 

```dart
void main() async {
 CachedQuery.instance.config(
  storage: await CachedStorage.ensureInitialized(),
 );
 runApp(const MyApp());
}
```
The Stored data is used to populate the initial data of a query. It is then updated anytime new data is returned from the
`queryFn`.

Create a custom storage object using your favourite package by extending the `StorageInterface`. 

## Error handling

By default, any errors throw during the `queryFn` are caught by the `Query`. These are then added to the state and sent 
down the query stream. Sometimes in development it is useful to rethrow errors for better visibility. Any query (or globally)
can be set to rethrow any error it catches.
```dart
  CachedQuery.instance.configFlutter(
    config: const QueryConfig(shouldRethrow: true),
  );
```
*:warning: Warning: This may cause some unexpected functionality in queries, so it is recommended to only use this as a development
tool.*

## Additional information

Inspired by fantastic packages from the react world. Read more information about them here:
* [SWR](https://swr.vercel.app/)
* [React Query](https://react-query.tanstack.com/)
* [RTKQuery](https://redux-toolkit.js.org/rtk-query/overview)

Full example found in the repo [here](https://github.com/D-James-GH/cached_query/tree/main/examples/query_builder)