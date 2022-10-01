# Flutter Bloc Query

We will use the [Json Placeholder Api](https://jsonplaceholder.typicode.com/) with a time delay to demonstrate 
cached data.

The source code for this example can be found here: https://github.com/D-James-GH/cached_query/tree/main/examples/simple_caching_with_bloc

For this example we will walk through the simplest form of caching with Cached Query and Flutter Bloc together. Flutter bloc is a popular implementation of the bloc pattern. It is very useful for keeping app architecture structured as team size and app size grows.

Using Flutter Bloc along side Cached Query was an important consideration when creating this package. However, following example should be transferable to any app architecture.


## How to integrate?
There are two implementation options to consider when using Cached Query with Flutter Bloc. 

### Map the query state to bloc state.

This option uses listens to the `Query` stream in the bloc and maps incoming query states into outgoing bloc states.

#### Pro

- Easy to integrate into existing apps as only the repository and bloc layers need adjusting, the presentation layer will remain the same.

#### Con
- The query key will always have a subscriber if the bloc is still in memory. When using a `QueryBuilder` the subscriber will be removed as soon as the component is removed from the widget tree.


### Pass the query to an `QueryBuilder` in the UI.

This option passes the `Query` through to the UI an uses the `QueryBuilder` to listen to state updates.

#### Pro
- As soon as the `QueryBuilder` is removed from the widget tree the subscriber is removed, allowing for more effective cache management.

#### Con
- Needs an Infinite Query to be used directly in the UI, either with a `QueryBuilder` or by listening/disposing of the stream.


## The Setup
Install the package.
```
flutter pub add cached_query_flutter
```

The setup is optional but to take full advantage of cached query we need to call the config function as early as possible.

The `config` function lets cached query know that it should re-fetch queries if the connectivity is established and if
the app comes back into view.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    refetchOnResume: true,
    refetchOnConnection: true,
  );
  runApp(const MyApp());
}
```

The main app will just consist of one page.  

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: PostPage(),
    );
  }
}
```

## Creating the Query

We create a service function which returns a `Query` for us to display. The `queryFn` is where the logic for the request 
needs to go. This function will be first called when a listener is added to the query stream. 

As the app is going to fetch a post by an id we have to add the id to the query key as well. The helper function below 
returns a key which includes the post id. 
```dart
String postKey(int id) => "postKey$id";
```

Each time the query key changes a new query will be created. 

```dart

Query<PostModel> getPostById(int id) {
  return Query<PostModel>(
    key: postKey(id),
    queryFn: () async {
      final uri = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts/$id',
      );
      final res = await http.get(uri);
      return Future.delayed(
        const Duration(milliseconds: 500),
        () => PostModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        ),
      );
    },
  );
}
```

## Post Model

This post model is a simple object that we serialize the json payload into.

```dart
class PostModel {
  final String title;
  final int id;
  final String body;
  final int userId;

  PostModel({
    required this.title,
    required this.id,
    required this.body,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    title: json["title"],
    body: json["body"],
    id: json["id"],
    userId: json["userId"],
  );
}
```

## Bloc Events

The events will be the same whether you are mapping the query to bloc state or not. 
We have one that fetches a new query by it's id and another that refreshes the current query.

```dart
abstract class PostEvent {}

class PostFetched extends PostEvent {
  final int id;
  PostFetched(this.id);
}

class PostRefreshed extends PostEvent {}
```

## Option 1 - Passing the query to the UI

### Bloc State
The Bloc state will differ depending on whether you are mapping the query state in the bloc or not.

If you would prefer to pass the query through to the UI then the state will hold the current query.

```dart
class PostWithBuilderState extends Equatable {
  final int currentId;
  final Query<PostModel> postQuery;

  const PostWithBuilderState({
    required this.currentId,
    required this.postQuery,
  });

  @override
  List<Object?> get props => [postQuery, currentId];
}
```

### The Bloc
When passing the query through to the UI the bloc is very simple. It simply needs to keep track of the current post id and pass through the new query when the current id changes.

```dart
class PostWithBuilderBloc
    extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {
  PostWithBuilderBloc()
      : super(PostWithBuilderState(currentId: 50, postQuery: getPostById(50))) {
    on<PostWithBuilderFetched>(_onPostFetched);
    on<PostWithBuilderRefreshed>(_onPostRefreshed);
  }

  FutureOr<void> _onPostFetched(
    PostWithBuilderFetched event,
    Emitter<PostWithBuilderState> emit,
  ) {
    final res = getPostById(event.id);
    emit(PostWithBuilderState(currentId: event.id, postQuery: res));
  }

  FutureOr<void> _onPostRefreshed(
    PostWithBuilderRefreshed event,
    Emitter<PostWithBuilderState> emit,
  ) {
    getPostById(state.currentId).refetch();
  }
}
```

### The UI

When passing the query through we will use the `QueryBuilder` to update the UI.

### Post Widget
The Post widget will be take a `PostModel` and display it.
```dart
class Post extends StatelessWidget {
  final PostModel post;

  const Post({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Title",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            post.title,
            textAlign: TextAlign.center,
          ),
          const Text(
            "Body",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            post.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```
### Post Page
The post page utilises a combination of the query builder and bloc builder to update the UI.

```dart
class PostWithBuilderPage extends StatelessWidget {
  const PostWithBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostWithBuilderBloc()..add(const PostWithBuilderFetched(50)),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: BlocSelector<PostWithBuilderBloc, PostWithBuilderState,
                Query<PostModel>?>(
              selector: (state) => state.postQuery,
              builder: (context, query) {
                if (query == null) return const SizedBox();
                return QueryBuilder(
                  query: query,
                  builder: (context, state) {
                    return Text(
                      state.status == QueryStatus.loading ? "loading..." : "",
                    );
                  },
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context
                    .read<PostWithBuilderBloc>()
                    .add(const PostWithBuilderRefreshed()),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                BlocBuilder<PostWithBuilderBloc, PostWithBuilderState>(
                  builder: (context, state) {
                    final currentId = state.currentId;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => context
                              .read<PostWithBuilderBloc>()
                              .add(PostWithBuilderFetched(currentId - 1)),
                          icon: const Icon(Icons.arrow_left),
                        ),
                        Text(currentId.toString()),
                        IconButton(
                          onPressed: () => context
                              .read<PostWithBuilderBloc>()
                              .add(PostWithBuilderFetched(currentId + 1)),
                          icon: const Icon(Icons.arrow_right),
                        ),
                      ],
                    );
                  },
                ),
                BlocSelector<PostWithBuilderBloc, PostWithBuilderState,
                    Query<PostModel>>(
                  selector: (state) => state.postQuery,
                  builder: (context, query) {
                    return QueryBuilder(
                      query: query,
                      builder: (context, state) {
                        if (state.data == null) {
                          return const SizedBox();
                        }
                        return Post(post: state.data!);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

```


## Option 2 - Mapping the Query State to Bloc State

### Bloc State

The state of the bloc will contain the id of the current post and the current post. These are stored separately as the id is treated as local state.

```dart
class PostState extends Equatable {
  final PostModel? post;
  final int currentId;
  final bool isLoading;

  const PostState({this.isLoading = false, this.currentId = 1, this.post});

  @override
  List<Object?> get props => [post, isLoading, currentId];
}
```
### The Bloc
Mapping the query state to bloc state requires Flutter Bloc's `emit.foreach`. The `emit.foreach` function will manage the stream subscription for us.  

:::info

It is important to use the `restartable` event transformer from Bloc Concurrency. This makes sure that there is only one query subscription at a time.

:::

```dart
class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState()) {
    /// !important: use the restartable transformer to automatically subscribe and
    /// unsubscribe when a new event comes in.
    on<PostFetched>(_onFetched, transformer: restartable());
    on<PostRefreshed>(_onRefresh);
  }

  FutureOr<void> _onFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) {
    return emit.forEach(
      getPostById(event.id).stream,
      onData: (queryState) {
        return PostState(
          currentId: event.id,
          post: queryState.data,
          isLoading: queryState.status == QueryStatus.loading,
        );
      },
    );
  }

  FutureOr<void> _onRefresh(PostRefreshed event, Emitter<PostState> emit) {
    getPostById(state.currentId).refetch();
  }
}
```
The `onData` function will be called whenever the query state is updated. This is where we map the current query state to a bloc state and return it. The listener will stay alive until there is a new `PostFetched` event.

### The UI

The UI will use the same post widget as option 1.

### Post Page

The post page here uses the bloc builder to update the UI. As the query state has already been listened to and mapped we don't need to use the query builder.

```dart
class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc()..add(PostFetched(50)),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: BlocSelector<PostBloc, PostState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) {
                return Text(
                  isLoading ? "loading..." : "",
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<PostBloc>().add(PostRefreshed()),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    final currentId = state.currentId;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => context
                              .read<PostBloc>()
                              .add(PostFetched(currentId - 1)),
                          icon: const Icon(Icons.arrow_left),
                        ),
                        Text(currentId.toString()),
                        IconButton(
                          onPressed: () => context
                              .read<PostBloc>()
                              .add(PostFetched(currentId + 1)),
                          icon: const Icon(Icons.arrow_right),
                        ),
                      ],
                    );
                  },
                ),
                BlocSelector<PostBloc, PostState, PostModel?>(
                  selector: (state) => state.post,
                  builder: (context, post) {
                    if (post == null) {
                      return const SizedBox();
                    }
                    return Post(post: post);
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

```

## Summary

There are two ways to use Cached Query along side Flutter Bloc. Each with their own pros and cons. If you are starting from scratch you get some memory management benefits from passing the query through to the UI. However, if you are bringing Cached Query into an existing app then wrapping an API call with a query then mapping the state is much simpler.













