# Simple Query Example
For this example we will walk through the simplest form of caching with Cached Query.

We will use the [Json Placeholder Api](https://jsonplaceholder.typicode.com/) with a time delay to demonstrate 
cached data.

The source code for this example can be found here: https://github.com/D-James-GH/cached_query/tree/main/examples/simple_caching

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

### Post Model

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

## The UI

The UI will consist of one page. This page will keep the current post id in local state and then increment or decrement 
the post id if the user chooses.

We are passing the `QueryBuilder` the query created above. The builder will call the builder function whenever a new 
`QueryState` is emitted.

Two query builders are being used, one in the app bar to display the loading and one in the body to display the post. Given 
the same **id** `getPostById` will always return the same instance of `Query` and therefore there is no need to store the 
query in a variable. We can just use `getPostById` in multiple places.

```dart
class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int currentId = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: QueryBuilder(
          query: service.getPostById(currentId),
          builder: (context, state) {
            return Text(
              state.status == QueryStatus.loading ? "loading..." : "",
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPost,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() => currentId = currentId - 1),
                  icon: const Icon(Icons.arrow_left),
                ),
                Text(currentId.toString()),
                IconButton(
                  onPressed: () => setState(() => currentId = currentId + 1),
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
            Post(id: currentId),
          ],
        ),
      ),
    );
  }

  void _refreshPost() {
    service.getPostById(currentId).refetch();
  }
}
```

### Post Widget

The Post widget is just responsible for displaying the post with a given id.

```dart
class Post extends StatelessWidget {
  final int id;

  const Post({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<PostModel>(
      // Can use key if the query already exists.
      queryKey: service.postKey(id),
      builder: (context, state) {
        final data = state.data;
        if (state.error != null) return Text(state.error.toString());
        if (data == null) return const SizedBox();
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
                data.title,
                textAlign: TextAlign.center,
              ),
              const Text(
                "Body",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                data.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
```

