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
The function getNextArg will always be called before the query function. Whatever is returned from getNextArg will be
passed to the queryFn. If the return value of getNextArg is null the state on the infinite query will be set to
hasReachedMax=true. This will block further page calls.

The data of an infinite query will always be a list of previously fetched pages. To fetch the next page use
infiniteQuery.getNextPage().

Re-fetching an infinite query re-fetches each page individually starting with the first page. This is to make sure every
page is upto date and there are no duplicate entries.


