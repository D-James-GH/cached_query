# Infinite List

An infinite list is a great way to display information to a user. An infinite query can be used to increase the user experience 
when flicking between lists or pages. For example if you have a product list with multiple filters, why not cache each list
so that the user doesn't have to wait when testing out new filters.

In this example we will use the [Json Placeholder Api](https://jsonplaceholder.typicode.com/) to demonstrate
loading and caching data.

The source code for this example can be found here: https://github.com/D-James-GH/cached_query/tree/main/examples/infinite_list

## The Setup
Install the package.
```
flutter pub add cached_query_flutter
```

The setup is optional but to take full advantage of cached query we need to call the config function as early as possible.

The `config` function lets cached query know that it should re-fetch queries if the connectivity is established and if
the app comes back into view.
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    config: QueryConfigFlutter(
      refetchOnResume: true,
      refetchOnConnection: true,
    ), 
    storage: await CachedStorage.ensureInitialized(),
  );
  runApp(const MyApp());
}
```

:::info
Optionally set up [`CachedStorage`](/docs/storage) for persistence to disk. This step is shown above.
:::

The main app will just consist of one page. Which will be an infinite list.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: PostListScreen(),
    );
  }
}
```
## The Query
We need to set up the query so that it requests a new page everytime the user scrolls to the bottom of the screen.
To do this we need to tell cached query how to calculate the arguments to pass to each page. For this example that is 
very simple. The RestApi we are using just needs a page number as a query parameter, so we can calculate the args like this:
```dart
getNextArg: (state) {
  if (state.lastPage?.isEmpty ?? false) return null;
  return state.length + 1;
},
```
The argument we need to pass to get the next page is always going to be the number of pages currently in the cache plus 1.
The only difference is if the last page returned an empty list. If the last page is empty then we return null. By returning 
null cached query knows that there are no more pages to be fetched and no more calls to `getNextPage` will be called.

In this example we are using `CachedStorage` to persist the query to disk. As our cache is a dart object (PostModel) we
need to pass a `storageDeserializer` function to the infinite query. If the storage has been set up when configuring `CachedQuery` 
and `storageDeserializer` field is not null then it will be used to parse the data returned from disk back into a dart object.

```dart
InfiniteQuery<List<PostModel>, int> getPosts() {
  return InfiniteQuery<List<PostModel>, int>(
    key: 'posts',
    config: QueryConfig(
      refetchDuration: const Duration(seconds: 2),
      // use a serializer for cached storage
      storageDeserializer: (dynamic postJson) {
        return (postJson as List<dynamic>)
            .map(
              (dynamic page) => PostModel.listFromJson(page as List<dynamic>),
        )
            .toList();
      },
    ),
    getNextArg: (state) {
      if (state.lastPage?.isEmpty ?? false) return null;
      return state.length + 1;
    },
    queryFn: (arg) async {
      final uri = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=10&_page=$arg',
      );
      final res = await http.get(uri);
      return PostModel.listFromJson(
        List<Map<String, dynamic>>.from(
          jsonDecode(res.body) as List<dynamic>,
        ),
      );
    },
  );
}
```
## The UI

The main list section of the UI is built using an `InfiniteQuery` builder. This calls its builder function whenever the 
state of the infinite query changes.

```dart
InfiniteQueryBuilder<List<PostModel>, int>(
  query: getPosts(),
  builder: (context, state, query) {
    final allPosts = state.data?.expand((e) => e).toList();
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (state.status == QueryStatus.error)
        SliverToBoxAdapter(
          child: DecoratedBox(
          decoration:
            BoxDecoration(color: Theme.of(context).errorColor),
            child: Text(
            state.error is SocketException
              ? "No internet connection"
                  : state.error.toString(),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (allPosts != null)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => Post(
              post: allPosts[i],
              index: i,
            ),
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
}),
```
The above builder will show different UI based on the current state of the query. For example, it will show a loading 
spinner at the bottom of the list when the state is loading. 

When building an infinite list it is important to utilise some sort of lazy builder to prevent excess memory being used. 
This could be a `ListView.builder` or in this case to have more flexibility we are using a `SliverList` with a 
`SliverChildBuilderDelegate`. This will only render the widgets within the viewport, which is especially important if 
the list contains images.

We also need to know when the list reaches the bottom so that we can request the next page. When the scroll controller
has reached 90% of the way down the `getNextPage()` method is called. Notice that there is no throttle function needed. 
The `getNextPage` will only ever make one request at a time. It stores the current request in a future variable and always
returns the same future until it has completed. This prevents spamming. 

The appbar and the list request the query in slightly different ways. The main List component calls the function that creates
the query directly. This will always return the same instance, as long as the key doesn't change. The appbar specifies 
the query via the key. This only works because we know the query definitely exists as we are creating it on the same page. 

```dart
void _onScroll() {
  final query = getPosts();
  if (_isBottom && query.state.status != QueryStatus.loading) {
    query.getNextPage();
  }
}
  
bool get _isBottom {
  if (!_scrollController.hasClients) return false;
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.offset;
  return currentScroll >= (maxScroll * 0.9);
}
```

All put together the full page looks like the following:

```dart
class PostListScreen extends StatefulWidget {
  static const routeName = '/';

  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InfiniteQueryBuilder(
          queryKey: 'posts',
          builder: (context, state, _) {
            return Row(
              children: [
                if (state.status == QueryStatus.loading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                const Text('posts'),
              ],
            );
          },
        ),
        centerTitle: true,
      ),
      body: InfiniteQueryBuilder<List<PostModel>, int>(
          query: getPosts(),
          builder: (context, state, query) {
            final allPosts = state.data?.expand((e) => e).toList();
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (state.status == QueryStatus.error)
                  SliverToBoxAdapter(
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: Theme.of(context).errorColor),
                      child: Text(
                        state.error is SocketException
                            ? "No internet connection"
                            : state.error.toString(),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (allPosts != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _Post(
                        post: allPosts[i],
                        index: i,
                      ),
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
          }),
    );
  }

  void _onScroll() {
    final query = getPosts();
    if (_isBottom && query.state.status != QueryStatus.loading) {
      query.getNextPage();
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
The Post widget is a simple stateless widget that displays the information held in the infinite query state.
```dart
class Post extends StatelessWidget {
  final PostModel post;
  final int index;

  const Post({Key? key, required this.post, required this.index})
      : super(key: key);

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
            child: Text(index.toString()),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(post.id.toString()),
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