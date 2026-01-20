# Infinite Query

An infinite query is used to cache an infinite list, which is a common occurrence with mobile apps. The caching works
in much the same way as a Query.

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
`hasNextPage = false`. This will block further page calls.

```dart
getNextArg: (state) {
  // If the last page is null then no request has happened yet.
  // If the last page is empty then the api has no more items.
    if (state.lastPage?.isEmpty ?? false) return null;
    return state.length + 1;
},
```

The data of an infinite query will always be of type `InfiniteQueryData`. For example, fetching a list of posts would result in type:

```dart

/// An Interface for infinite query data.
final class InfiniteQueryData<List<Post>, int> {
  /// The pages of data returned from the queryFn
  List<List<Post>> pages;

  /// The arguments used to fetch the page of the same index
  List<int> args;
}
```

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
necessary to use the return value though, as the state will also be emitted down the query stream.

Each request for `getNextPage` will be de-duplicated, so only one page request can be made at a time. This normally reduces
the need for a throttle in an infinite list.

## Get Previous Page

An infinite query can also fetch the previous page using `infiniteQuery.getPreviousPage()`.

It works in the same way as `getNextPage` but will use the `getPreviousArg` function to get the argument for the previous page.

Full example can be found: https://github.com/D-James-GH/cached_query/blob/main/examples/full/lib/posts/post_service.dart

```dart

InfiniteQuery<List<PostModel>, int> getPosts() {
  return InfiniteQuery(
    key: 'posts',
    getNextArg: (state) {
      // initial arg
      if (state == null || state.args.isEmpty) return 5;

      final lastArg = state.args.last;
      return lastArg + 1;
    },
    getPrevArg: (state) {
      final firstArg = state?.args.firstOrNull;
      if (firstArg == null || firstArg <= 1) return null;
      return firstArg - 1;
    },
    queryFn: (arg) async {
       ///...fetch posts with arg
    },
  );
}
```

## Invalidation and Re-fetching

When an infinite query becomes stale it needs to be refreshed, just like a query. By default, each page will be refreshed sequentially, starting from the index 0.
This is the safest way to ensure the data is consistent.

However, if the number of pages is large this can take a long time. To adjust this behavior the property `onPageRefetched` can be used.
If at anytime a value is returned from `onPageRefetched` that value will be used as the new cache and no further pages will be refetched.

Here are two examples of how this can be used:

1. If the first page is different only return the first page. This will reset the list to the first page only if the first page has changed. This prevents the whole list being refetched.

```dart
final OnPageRefetched<T, Arg> onPageRefetched = (
  T page,
  InfiniteQueryData<T, Arg> currentResult,
  InfiniteQueryData<T, Arg> cachedData,
) {
  if (page != cachedData.pages.firstOrNull && currentResult.pages.length == 1) {
    return currentResult;
  }
  return null;
}

```

2.  Only refetch the whole list if the first pages are different.
    Useful if a list is only added to at the start.
    If the first page hasn't changed then the rest of the pages can be assumed to be the same.

```dart
final OnPageRefetched<T, Arg> onPageRefetched = (
  T page,
  InfiniteQueryData<T, Arg> currentResult,
  InfiniteQueryData<T, Arg> cachedData,
) {
  if (page == cachedData.pages.firstOrNull && currentResult.pages.length == 1) {
    return cachedData;
  }
  return null;
}

```

## Side Effects

There are two side effects that can be passed to an infinite query.

- `onSuccess` - This is called after the query function succeeds but before the query state is updated.
- `onError` - This is called if the query function fails but before the query state is updated.

```dart
final query = InfiniteQuery<String>(
  key: "sideEffects",
  onSuccess: (dynamic r) {
    // do something with the response
  },
  onError: (dynamic e){
    // do something with the error
  },
  queryFn: () async {
    //...queryFn
  },
);
```

## Local Cache

Each infinite query can take a local cache as a prop.

For more information, see [local cache](/docs/guides/query#local-cache).
