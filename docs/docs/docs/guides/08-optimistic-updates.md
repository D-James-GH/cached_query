# Optimistic Updates

The `onStartMutation` lifecycle hook can be used to update the cache before the mutation is sent. It gets passed the same
argument you pass to mutate.

The example below updates an infinite list and adds the new query to the start of the list.

There are a few steps to note:

1. Take a snapshot of the current data to use as a fallback in case the mutation fails. The fallback can be any data,
   but usually it's best to use the current data.
2. Update the infinite query data to add the new post to the start of the list.
3. Return the snapshot of the current data as the fallback.

Inside `onError` the fallback is used to restore the cache if the mutation fails.

Finally, the `invalidateQueries` prop is used to invalidate the posts query after the mutation has completed successfully.
This will ensure the list is re-fetched and in sync with the server. If the list has been updated correctly the user should
not notice any change when the list is refetched.

```dart
Mutation<PostModel, PostModel> createPost() {
  return Mutation<PostModel, PostModel>(
    key: "createPost",
    invalidateQueries: ['posts'],
    mutationFn: (post) async {
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
      final query = CachedQuery.instance
          .getQuery<InfiniteQuery<List<PostModel>, int>>("posts");

      final fallback = query?.state.data;

      query?.update(
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

      return fallback;
    },
    onError: (arg, error, fallback) {
      if (fallback != null) {
        CachedQuery.instance
            .getQuery<InfiniteQuery<List<PostModel>, int>>("posts")
            ?.update(
              (old) => fallback as InfiniteQueryData<List<PostModel>, int>,
            );
      }
    },
  );
}
```

## Updating with received data

Often the response of a post request is the correct data, so you may want to update the cache after the mutation.
Use `onSuccess` to do just that.

The example below updated the cache after the mutation has completed using the response.

```dart
Mutation<PostModel, PostModel>(
  queryFn: (post) async {
    ...
  },
  onSuccess: (response, postArg) {
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
      }
    );
  },
);
```
