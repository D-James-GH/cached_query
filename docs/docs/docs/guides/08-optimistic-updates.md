# Optimistic Updates

The `onStartMutation` lifecycle hook can be used to update the cache before the mutation is sent. It gets passed the same
argument you pass to mutate. 

The example below updates an infinite list and adds the new query to the start of the list. To make sure the data is in 
sync with the server it is also re-fetching the posts list once the mutation completes all in the background for improved
UX.
```dart
Mutation<PostModel, PostModel>(
  refetchQueries: ["posts"],
  queryFn: (post) async {
    final res = await _service.createPost(
      title: post.title,
      userId: post.userId,
      body: post.body,
    );
    return PostModel.fromJson(res);
  },
  onStartMutation: (postArg) {
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
  },
);
```

## Rollback changes
Anything that is returned from the `onStartMutation` hook will be passed as the third argument to `onError` allowing you
to rollback changes if something fails.

```dart
Mutation<PostModel, PostModel> createPost() {
  return Mutation<PostModel, PostModel>(
    key: "createPost",
    invalidateQueries: ['posts'],
    queryFn: (post) async {
      final res = await Future.delayed(
        const Duration(milliseconds: 400),
        () => {
          "id": 123,
          "title": post.title,
          "userId": post.userId,
          "body": post.body,
        },
      );
      return PostModel.fromJson(res);
    },
    onStartMutation: (newPost) {
      final query = CachedQuery.instance.getQuery("posts")
          as InfiniteQuery<List<PostModel>, int>;

      final fallback = query.state.data;
      query.update(
        (old) => [
          [newPost, ...?old?.first],
          ...?old?.sublist(1).toList()
        ],
      );

      return fallback;
    },
    onSuccess: (args, newPost) {},
    onError: (arg, error, fallback) {
      CachedQuery.instance.updateQuery(
        key: "posts",
        updateFn: (dynamic old) => fallback as List<List<PostModel>>,
      );
    },
  );
}
```
In the above example we optimistically update the posts query with a new entry and return the old data from `onStartMutation`.
If the queryFn throws an error then we set the infinite query data to be the same as it was before the mutation.

## Updating with received data
Often the response of a post request is the correct data, so you may want to update the cache after the mutation.
Use `onSuccess` to do just that.

The example below updated the cache after the mutation has completed using the response.

```dart
Mutation<PostModel, PostModel>(
  refetchQueries: ["posts"],
  queryFn: (post) async {
    final res = await _service.createPost(
      title: post.title,
      userId: post.userId,
      body: post.body,
    );
    return PostModel.fromJson(res);
  },
  onSuccess: (response, postArg) {
    CachedQuery.instance.updateQuery(
      key: "posts",
      updateFn: (dynamic old) {
        if(old is! List<List<PostModel>>) {
          return old;
        }
        
        return [
          [response, ...old[0]],
          ...old.sublist(1).toList()
        ],
      }
    );
  },
);
```
