# Mutations

A mutation should be used to update data on the server. By its self a mutation doesn't really do anything. However, it
comes with a few useful options for updating previously fetched queries.

## Creating a mutation

A mutation is a small wrapper around a mutationFn which is an asynchronous function that will update the server. It takes two generic
arguments, the first is the mutationFn return type and the second is the argument type that will be passed to the mutationFn.

```dart
final createPostMutation = Mutation<ReturnType, ArgType>(
  mutationFn: (post) => createPost(post),
);
```

To activate a mutation call the mutate function on the `Mutation` object.

```dart
final post = PostModel(
  title: "Post title",
);
await createPostMutation.mutate(post);
```

The mutate function takes a single argument which must be the `ArgType` specified when instantiating the mutation. This
argument will be passed to the mutationFn. The mutate method returns a future that completes when the mutationFn completes,
so this can be awaited if you need.

## Invalidating Queries

It is often a good idea to invalidate all queries that the mutation will affect. To easily do this pass a list of query
keys when instantiating the mutation. If the mutation is successful all the queries matching the keys will be invalidated.

Invalidation marks the query as stale and will re-fetch the query if it has listeners.

```dart
final createPostMutation = Mutation<PostModel, PostModel>(
  invalidateQueries: ['posts'],
  mutationFn: (post) => createPost(post),
);
```

## Re-fetching Queries

To re-fetch a set of queries after a mutation completes pass a list of keys to the `refetchQueries` prop. This will loop
through the keys are force a re-fetch on each query.

```dart
final createPostMutation = Mutation<PostModel, PostModel>(
  refetchQueries: ['posts'],
  mutationFn: (post) => createPost(post),
);
```

## Mutation Key and Cache

Unlike a query the mutation key is optional. A mutation will not be cached unless it is given a key. Caching a mutation
is useful if the current state of the mutation is needed in multiple places. For example, you could have a loading spinner
in the app bar while the mutation is called in a form submit button. In this case you would use a key to refer to the
same mutation.

```dart
final createPostMutation = Mutation<PostModel, PostModel>(
  key: "post mutation",
  mutationFn: (post) => createPost(post),
);
```

### Mutation stream

Just like a query a mutation has a stream which emits the `MutationState` whenever it changes. There is no `cacheDuration`
on a mutation so whenever the last listener is removed from a mutation it is immediately removed from memory.

## Mutation Lifecycle

There are three lifecycle call backs for a mutation.

- `onStartMutation` is called before the mutationFn. This can be used for [optimistic updates](/docs/guides/optimistic-updates).
- `onSuccess` is called after the mutationFn if the mutation is successful.
- `onError` is called after the mutationFn if the mutation fails.

### Error handling

The `onError` callback is called if the mutationFn throws an error. Sometimes you may need to handle the error where you
call the `mutate` function. To do this you can await the `mutate` function and use the mutation state to view the error.

```dart
final mutation = updateUser();
await mutation.mutate(user);
if(mutation.state.status == QueryStatus.error){
  // handle error
}
```
