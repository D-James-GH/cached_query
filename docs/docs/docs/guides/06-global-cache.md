# Global Cache

The instance of the query cache is available through a singleton `CachedQuery.instance`. It has a few useful utilities on it.

## Where Query
Where query works much like where on an iterable. It returns a list of queries and infinite queries that satisfy the 
given test.

The example below returns all queries/infinite queries whose key contains the word "Post".

*Note: The key on a query object will always be a string*
```dart
final queries = CachedQuery.instance.whereQuery((query) => query.key.contains("post"));
```

## Re-fetch, Invalidate and Delete

Use the Cached Query instance to easily invalidate or re-fetch the whole cache or a single key.

Refetch multiple queries at once by passing a list of keys.
```dart
CachedQuery.instance.refetchQueries(["posts"]);
```

Invalidating will mark the specified key as stale. To invalidate the whole cache don't pass a key.
```dart
CachedQuery.instance.invalidateCache("posts");

// Invalidate the whole cache
CachedQuery.instance.invalidateCache();
```


Deleting will remove the specified key immediately. To delete the whole cache leave the key as null.
```dart
// Optionally delete the stored values as well.
CachedQuery.instance.deleteCache(key: "posts", deleteStorage: true);

// Delete the whole cache
CachedQuery.instance.deleteCache(deleteStorage: true);
```

## Manually Adding and Removing Queries 
You can manually add or get a query from the cache, although it is not normally necessary to add as the query will call
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

Either use `updateQuery` or `updateInfiniteQuery` to update a query. Any changes will be emitted down the query stream.
Both update functions require a key and a callback which will be passed the current data and return the result.
```dart
CachedQuery.instance.updateInfiniteQuery<List<PostModel>>(
  key: "posts",
  updateFn: (old) => [
    [response, ...old![0]],
    ...old.sublist(1).toList()
  ],
);
```


