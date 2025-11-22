# Global Cache

The instance of the query cache is available through a singleton `CachedQuery.instance`. It has a few useful utilities on it.

## Where Query

Where query works much like where on an iterable. It returns a iterable of queries and infinite queries that satisfy the
given test.

The example below returns all queries/infinite queries whose key contains the word "Post".

_Note: The key on a query object will always be a string, the original key is accessible under unencodedKey_

```dart
final queries = CachedQuery.instance.whereQuery((query) => query.key.contains("post"));
```

## Invalidate Queries

Invalidating will mark the specified key as stale. By default `invalidate` will refetch any query that has listeners.
The behavior can be changed by passing the `refetchActive` (defaults to true) and `refetchInactive` (defaults to false) parameters.

To invalidate the whole cache don't pass a key.

```dart
CachedQuery.instance.invalidateCache(keys: ["posts"]);

// or invalidate by finding a query
CachedQuery.instance.whereQuery((q) => q.key.startsWith("todos/")).forEach((q) => q.invalidate());

// Invalidate the whole cache
CachedQuery.instance.invalidateCache();
```

## Re-fetch, and Delete

Use the Cached Query instance to easily re-fetch the whole cache or a single key.

Refetch multiple queries at once by passing a list of keys.
:::info
Refetch is similar to invalidate however, it can ignore the stale duration and force a re-fetch.
:::

```dart
CachedQuery.instance.refetchQueries(keys: ["posts"]);
```

Refetch multiple queries at once by passing a filter.

```dart
CachedQuery.instance.refetchQueries(
    filterFn: (unencodedKey, key) => key.startsWith("todos/"),
);
```

Deleting will remove the specified key immediately. To delete the whole cache leave the key as null.

```dart
// Optionally delete the stored values as well.
CachedQuery.instance.deleteCache(key: "posts", deleteStorage: true);

// Delete the whole cache
CachedQuery.instance.deleteCache(deleteStorage: true);
```

## Manually Adding and Removing Queries

You can manually add or get a query from the cache, although it is not normally necessary to add it as the query will call
this for you.

To add a query or infinite query to cache:

```dart
CachedQuery.instance.addQuery(query);
```

To get a query or infinite query from cache:

```dart
CachedQuery.instance.getQuery(key);
```

## Updating the Cache

It is often useful to be able to update the cache manually, for example, when performing [optimistic updates](/docs/guides/optimistic-updates)

### Setting query data

Setting a query directly alters the data stored, if no query is available then one will be created.

If a new query is added using `setQueryData` it will be created with an empty `queryFn`. Any subsequent 
fetches will fail until a query or infinite query with the same key is created. 

```dart

CachedQuery.instance.setQueryData<String>(
    key: "query_key",
    data: "new_value",
  );

final query = CachedQuery.instance.getQuery("query_key");

/// THIS WILL FAIL
query.refetch();

```

To allow use of fetching, create an infinite query or query with the same key: 

```dart
final query = Query<String>(
  key: "query_key",
  queryFn: (_) async => "",
);
// WILL NOT FAIL
query.refetch();
```
or for infinite query: 
```dart
final query = InfiniteQuery<String, int>(
  key: "query_key",
  getNextArg: (state) => (state?.length ?? 0) + 1,
  queryFn: (_) async => "",
);
// WILL NOT FAIL
query.refetch();
```

### Updating query data

Updating query data requires that a query already be present in the cache. It will not create a new 
query if the key doesn't exist.

Use `updateQuery` to update a query or an infinite query. Any changes will be emitted down the query stream.
The update function requires either a `key` or a `filterFn` to select the query to update. The `updateFn` is then called with the current data and should return the new data.

```dart
CachedQuery.instance.updateQuery(
  key: "posts",
  updateFn: (dynamic old) {
    return InfiniteQueryData(
        args: old?.args ?? [],
        pages: [
            [newPost, ...?old?.pages.first],
            ...?old?.pages.sublist(1),
        ],
    );
  },
);
```

:::info
As an alternative to using `CachedQuery.instance.updateQuery` you can also use the `whereQuery` method in tandem with the `update` method on the query object itself.

This would have better type safety but would result in more code.

```dart
CachedQuery.instance.whereQuery((q) => q.key == "posts").forEach((query) {
    query.update(
      (old) {
        return InfiniteQueryData(
          args: old?.args ?? [],
          pages: [
            [newPost, ...?old?.pages.first],
            ...?old?.pages.sublist(1),
          ],
        );
      },
    );
  },
);
```

:::

## Query Key Filter Function

Many of the functions on the CachedQuery instance take a key or a filterFn. A key is a direct reference to a cached query where as the `filterFn` allows for selecting multiple queries at once.

For example, say you have a list of todos, and each todo has been fetched with the key `"todos/${id}"`, if a user selects a "complete all" button then we will want to find all the todos in the cache and update them, regardless of their id.

```dart
CachedQuery.instance.updateQuery(
  updateFn: (dynamic oldData){
    if(oldData is Todo){
      return oldData?.copyWith(complete: true);
    }
  },
  filterFn: (unencodedKey, key) => key.startsWith("todos/"),
);
```

Notice that the `filterFn` passes through two arguments; `unencodedKey` and `key`. The `unencodedKey` is the original key the you passed to the query. The `key` is the json-encoded string of the `unencodedKey`. Using the example above, if the todo keys were altered to be `["todo", id]` then we could use the unencoded key to filter the queries.

```dart
CachedQuery.instance.updateQuery<Todo>(
  updateFn: (dynamic oldData){
    if(oldData is Todo){
      return oldData?.copyWith(complete: true);
    }
  },
  filterFn: (unencodedKey, key) => unencodedKey is List && unencodedKey.first == "todo",
);
```
