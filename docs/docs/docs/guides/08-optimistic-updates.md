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
    CachedQuery.instance.updateInfiniteQuery<List<PostModel>>(
      key: "posts",
      updateFn: (old) => [
        [postArg, ...old![0]],
        ...old.sublist(1).toList()
      ],
    );
  },
);
```

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
    CachedQuery.instance.updateInfiniteQuery<List<PostModel>>(
      key: "posts",
      updateFn: (old) => [
        [response, ...old![0]],
        ...old.sublist(1).toList()
      ],
    );
  },
);
```
