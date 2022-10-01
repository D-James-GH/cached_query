# Infinite List with Bloc

This blog will demonstrate how to create a cached infinite list with cached query and flutter bloc.

There are two options when integrating cached query with flutter bloc.

The code for this example can be found here: 
https://github.com/D-James-GH/cached_query/tree/main/examples/infinite_list_with_bloc

There are two implementation options to consider when using Cached Query with Flutter Bloc. In this example will go through using both the query builder and mapping a query into bloc state. For more information on the pros and cons of each way go to [Flutter Bloc Query](/examples/with-flutter-bloc#how-to-integrate)

## Data Layers

Both methods will required the same service and repository. For this example we will use the [json placeholder](https://jsonplaceholder.typicode.com/) api. We are also adding a one second delay to the http request purely to demonstrate the caching fully.

### Service

A simple service function that will take the current page number and the limit to be returned.

```dart
class PostService {
  Future<List<dynamic>> getPosts({
    required int limit,
    required int page,
  }) async {
    final uri = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page',
    );
    final res = await http.get(uri);
    // extra delay for testing purposes
    return Future.delayed(
      const Duration(seconds: 1),
      () => jsonDecode(res.body) as List<dynamic>,
    );
  }
}
```

### Repository

Here we create the infinite query. The query function will not be called until the query has a listener or `result` is called.

```dart
class PostRepository {
  final _service = PostService();

  InfiniteQuery<List<PostModel>, int> getPosts() {
    return InfiniteQuery<List<PostModel>, int>(
      key: 'posts',
      getNextArg: (state) {
        if (state.lastPage?.isEmpty ?? false) return null;
        return state.length + 1;
      },
      queryFn: (page) async => PostModel.listFromJson(
        await _service.getPosts(page: page, limit: 10),
      ),
    );
  }
}
```
The return value of `getNextArg` will be passed to the `queryFn` which in this case is an integer. If the last page is **Not** null and it is empty then it means there are no more pages that can be fetched and therefore we return null from `getNextArg`. Returning null sets the state of the infinite query the `hasReachedMax`. If the last page was null or had data then we return the length of the state plus 1 for the next page.

### Post Model

```dart
class PostModel extends Equatable {
  final int id;
  final String title;
  final String body;
  final int userId;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        userId: json["userId"],
      );

  static List<PostModel> listFromJson(List<dynamic> json) => json
      .map(
        (dynamic postJson) =>
            PostModel.fromJson(postJson as Map<String, dynamic>),
      )
      .toList();

  @override
  List<Object?> get props => [id, title, body, userId];
}
```
Using Equatable or freezed to override the equality operator is a good idea, as Cached Query uses equality when determining which pages need re-fetching.

## Bloc without the InfiniteQueryBuilder

As mentioned at the start, when integrating cached query into an existing project you can map the stream of the infinite query into a stream of bloc states.

The following section will focus on mapping the infinite query stream to bloc states.

### The Events


We only need two events in the bloc. One to initialise the query and listen to the stream (`PostsFetched`) and one to get the next page.

```dart
@immutable
abstract class PostEvent extends Equatable {}

class PostsFetched extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PostsNextPage extends PostEvent {
  @override
  List<Object?> get props => [];
}
```



### Bloc state

The bloc state consists of the current list of posts to show, whether the infinite query has any more pages and the current status of the requests.

```dart
enum PostStatus { loading, initial, success }

class PostState extends Equatable {
  final PostStatus status;
  final List<PostModel>? posts;
  final bool hasReachedMax;

  const PostState({
    this.status = PostStatus.initial,
    this.posts,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [posts, status, hasReachedMax];

  PostState copyWith({
    PostStatus? status,
    List<PostModel>? posts,
    bool? hasReachedMax,
    bool? isMutationLoading,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
```
### The Bloc

We use Flutter Blocs `emit.forEach` to manage the stream subscription for us. Any time data is emitted from the infinite query then `onData` will be called. In side `onData` we map the incoming infinite query state to a bloc state.

:::info

As the event `PostsFetched` can be called multiple times, it is important to add the `restartable` event transformer from [Bloc Concurrency](https://pub.dev/packages/bloc_concurrency). This will make sure there can only be one listener added to the infinite query at a time.

:::

To get the next page we just get the infinite query from the repository and call `getNextPage` any state updates will be reflected in the bloc because we are listening to the infinite query stream.

:::note

Notice there is no event transformer or throttle on the `getNextPage` event. This is not needed as called to `getNextPage` are de-duplicated so only one can happen at a time.

:::


```dart 
class PostBloc extends Bloc<PostEvent, PostState> {
  final _repo = PostRepository();

  PostBloc() : super(const PostState()) {
    // use restartable
    on<PostsFetched>(_onPostsFetched, transformer: restartable());
    on<PostsNextPage>(_onPostsNextPage);
  }

  FutureOr<void> _onPostsFetched(
    PostsFetched event,
    Emitter<PostState> emit,
  ) {
    final query = _repo.getPosts();
    // Subscribe to the stream from the infinite query.
    return emit.forEach<InfiniteQueryState<List<PostModel>>>(
      query.stream,
      onData: (queryState) {
        return state.copyWith(
          posts: queryState.data?.expand((page) => page).toList() ?? [],
          status: queryState.status == QueryStatus.loading
              ? PostStatus.loading
              : PostStatus.success,
          hasReachedMax: queryState.hasReachedMax,
        );
      },
    );
  }

  void _onPostsNextPage(PostEvent _, Emitter<PostState> __) {
    // No need to store the query in a variable as calling getPosts() again will
    // retrieve the same instance of infinite query.
    _repo.getPosts().getNextPage();
  }
}
```

### The UI

In order to take advantage of re-fetch on connection and re-fetching when the app comes back into view we need to configure Cached Query Flutter. 

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CachedQuery.instance
      .configFlutter(refetchOnResume: true, refetchOnConnection: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        PostListPage.routeName: (_) => const PostListPage(),
        PostListWithBuilderPage.routeName: (_) =>
            const PostListWithBuilderPage(),
      },
    );
  }
}
```

#### Post Widget
The post component will very simply display each posts data. 

```dart
class Post extends StatelessWidget {
  final PostModel post;

  const Post({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text("id:${post.id.toString()}"),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(post.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Post List Page

The post list page is responsible for displaying the posts and keep track of the scroll position. I displays a loading icon in the app bar whenever the post bloc status is loading.

:::tip

Scope the bloc to a certain section of the UI. This will mean that when the page is removed from the widget tree the listener on the infinite query will also be removed.

:::

When the list scrolls to 90% of the screen the next page event will be added to the bloc. All of these calls will be de-duplicated so there is no need to throttle this call.

```dart
class PostListPage extends StatelessWidget {
  static const routeName = '/';
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return SizedBox(
                width: 150,
                child: Stack(
                  children: [
                    if (state.status == PostStatus.loading)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    const Center(child: Text('Posts')),
                  ],
                ),
              );
            },
          ),
        ),
        body: const _List(),
      ),
    );
  }
}

class _List extends StatefulWidget {
  const _List();

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostBloc>().add(PostsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        final posts = state.posts;
        if (posts != null) {
          return ListView.builder(
            controller: _scrollController,
            itemCount:
                !state.hasReachedMax && state.status == PostStatus.loading
                    ? posts.length + 1
                    : posts.length,
            itemBuilder: (context, i) {
              if (i < posts.length) {
                return Post(post: posts[i]);
              }
              return const Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }
        if (state.status == PostStatus.loading) {
          return const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Text("no posts found");
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostsNextPage());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
```

## Adding the IntiniteQueryBuilder

For better cache management it is a good idea to use the `InfiniteQueryBuilder`. When the builder is removed from the widget tree the listener to the cache will be removed immediately. Unlike listening to the query in the bloc where the listener will only be removed when the bloc is removed from the tree.

### Events 

There are the same two events here. One to fetch the initial list and one to get the next page.
```dart
@immutable
abstract class PostWithBuilderEvent {}

class PostsWithBuilderFetched extends PostWithBuilderEvent {}

class PostsWithBuilderNextPage extends PostWithBuilderEvent {}
```

## State

The state is simpler when using the query builder. The success state only needs to hold the `InfiniteQuery` itself.

```dart
abstract class PostWithBuilderState extends Equatable {}

class PostWithBuilderInitial extends PostWithBuilderState {
  @override
  List<Object?> get props => [];
}

class PostWithBuilderSuccess extends PostWithBuilderState {
  final InfiniteQuery<List<PostModel>, int> postQuery;

  PostWithBuilderSuccess({required this.postQuery});

  @override
  List<Object?> get props => [postQuery];
}
```

### The Bloc

The bloc is also simpler as its only responsible is to stream the infinite query directly to the UI.

```dart
class PostWithBuilderBloc extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {
  final _repo = PostRepository();

  PostWithBuilderBloc() : super(PostWithBuilderInitial()) {
    on<PostsWithBuilderFetched>(_onPostsFetched);
    on<PostsWithBuilderNextPage>(_onPostsNextPage);
  }

  FutureOr<void> _onPostsFetched(
    PostsWithBuilderFetched _,
    Emitter<PostWithBuilderState> emit,
  ) {
    final query = _repo.getPosts();
    emit(PostWithBuilderSuccess(postQuery: query));
  }

  void _onPostsNextPage(
    PostWithBuilderEvent _,
    Emitter<PostWithBuilderState> __
  ) {
    // No need to store the query in a variable as calling getPosts() again will
    // retrieve the same instance of infinite query.
    _repo.getPosts().getNextPage();
  }
}
```
### The UI

The UI with the build is must the same as with the bloc builder. 



```dart
class PostListWithBuilderPage extends StatelessWidget {
  static const routeName = 'postWithBuilderList';
  const PostListWithBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostWithBuilderBloc()..add(PostsWithBuilderFetched()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Posts With Builder"),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_right_alt),
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                PostListPage.routeName,
              ),
            )
          ],
        ),
        body: const _List(),
      ),
    );
  }
}
```
The List component this time uses a custom scroll view so that other loading widgets and information banners can be displayed in the list.

We pass the infinite query from the bloc state to the Infinite Query Builder. The builder will then call the builder function whenever a new `InfiniteQueryState` is emitted down the query stream.

```dart
class _List extends StatefulWidget {
  const _List();

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostWithBuilderBloc, PostWithBuilderState>(
      builder: (context, state) {
        if (state is PostWithBuilderSuccess) {
          return InfiniteQueryBuilder<List<PostModel>, int>(
            query: state.postQuery,
            builder: (context, state, query) {
              if (state.data != null && state.data!.isNotEmpty) {
                final allPosts = state.data!.expand((e) => e).toList();
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (state.status == QueryStatus.error &&
                        state.error is SocketException)
                      SliverToBoxAdapter(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Theme.of(context).errorColor),
                          child: const Text(
                            "No internet connection",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Post(post: allPosts[i]),
                        childCount: allPosts.length,
                      ),
                    ),
                    if (state.status == QueryStatus.loading)
                      const SliverToBoxAdapter(
                        child: Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                    )
                  ],
                );
              }
              if (state.status == QueryStatus.loading) {
                return const Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const Text("no posts found");
            },
          );
        }
        return const Text("No query");
      },
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostWithBuilderBloc>().add(PostsWithBuilderNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
```

## Wrap up

We have shown two examples of how an infinite list can be cached using Cached Query and Flutter Bloc together. The same integration techniques could easily be transferable to other state management options.

It is up to you which method of integration is best for your app and architecture. 


