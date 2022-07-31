# Infinite Query

An infinite query is used to cache an infinite list, which is a common occurrence with mobile apps. The caching works
in much the same way as a Query and actually extends the QueryBase.

Infinite query takes two generic arguments, the first being the data that will be returned from the queryFn and the
second is the type of the argument that will be passed to the queryFn.

```dart
final postsQuery = InfiniteQuery<List<PostModel>, int>(
  key: 'posts',
  getNextArg: (state) {
    if (state.lastPage?.isEmpty ?? false) return null;
    return state.length + 1;
  },
  queryFn: (page) => fetchPosts(endpoint: "/api/data?page=${page}"),
);
```

## Query Arguments

The function getNextArg will always be called before the query function. Whatever is returned from `getNextArg` will be
passed to the `queryFn`. 

If the return value of getNextArg is null the state on the infinite query will be set to
`hasReachedMax = true`. This will block further page calls.
```dart
getNextArg: (state) {
  // If the last page is null then no request has happened yet. 
  // If the last page is empty then the api has no more items.
    if (state.lastPage?.isEmpty ?? false) return null;
    return state.length + 1;
},
```

The data of an infinite query will always be a list of previously fetched pages. 
```dart
data: [
  page1, 
  page2,
]
```
If a page is also a list the structure will be. 

```dart
data: [
  [item, item2],
  [item3, item4],
]
```
This makes it easier to track which page returned what.

## Get Next Page
To fetch the next page use `infiniteQuery.getNextPage()`.

```dart
final postsQuery = InfiniteQuery<List<PostModel>, int>(
  key: 'posts',
  getNextArg: (state) {
    if (state.lastPage?.isEmpty ?? false) return null;
    return state.length + 1;
  },
  queryFn: (page) => fetchPosts(endpoint: "/api/data?page=${page}"),
);
---
final nextPage = await postsQuery.getNextPage();
```
The `getNextPage` function returns a future of the infinite query state after the next page has completed. It is not 
necessary to use this though, as the state will also be emitted down the query stream.

Each request for `getNextPage` will be de-duplicated, so only one request can be made at a time. This normally reduces 
the need for a throttle in an infinite list.

## Invalidation and Re-fetching

Re-fetching an infinite query re-fetches each page individually starting with the first page. This is to make sure every
page is upto date and there are no duplicate entries.

When an infinite query becomes stale it needs to be refreshed, just like a query. By default, to prevent unnecessary api 
calls, the infinite query will fetch the first page only and check to see if it is different to the cached first page.
If the pages are different, then all pages will be re-fetched sequentially, if they are equal then the infinite query 
will not re-fetch anything else. You can turn this feature off and force pages always to refetch sequentially using
`forceRevalidateAll = true`.


The first page will be compared to prevent re-fetching if list hasn't changed:
```dart
final postsQuery = InfiniteQuery<List<PostModel>, int>(
  key: 'posts',
  getNextArg: (state) {
    if (state.lastPage?.isEmpty ?? false) return null;
    return state.length + 1;
  },
  queryFn: (page) => fetchPosts(endpoint: "/api/data?page=${page}"),
);
```

When stale all pages will always be re-fetched:
```dart
final postsQuery = InfiniteQuery<List<PostModel>, int>(
  key: 'posts',
  forceRevalidateAll: true,
  getNextArg: (state) {
    if (state.lastPage?.isEmpty ?? false) return null;
    return state.length + 1;
  },
  queryFn: (page) => fetchPosts(endpoint: "/api/data?page=${page}"),
);
```




