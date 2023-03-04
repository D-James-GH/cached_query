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
CachedQuery.instance.refetchQueries(keys: ["posts"]);
```

Refetch multiple queries at once by passing a filter.
```dart
CachedQuery.instance.refetchQueries(
    filterFn: (unencodedKey, key) => key.startsWith("todos/"),
);
```

Invalidating will mark the specified key as stale. To invalidate the whole cache don't pass a key.
```dart
CachedQuery.instance.invalidateCache(key: "posts");

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

Use `updateQuery` to update a query or an infinite query. Any changes will be emitted down the query stream.
The update function requires either a `key` or a `filterFn` to select the query to update. The `updateFn` is then called with the current data and should return the new data.

```dart
CachedQuery.instance.updateQuery(
  key: "posts",
  updateFn: (dynamic old) {
    if (old is List<List<PostModel>>) {
      return <List<PostModel>>[
        [newPost, ...old[0]],
        ...old.sublist(1).toList()
      ];
    }
  },
);
```

:::info
As an alternative to using `CachedQuery.instance.updateQuery` you can also use the `whereQuery` method in tandem with the `update` method on the query object itself.  

This would have better type safety but would result in more code.
``
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
