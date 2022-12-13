# Infinite List

An infinite list is a great way to display information to a user. An infinite query can be used to increase the user experience 
when flicking between lists or pages. For example if you have a product list with multiple filters, why not cache each list
so that the user doesn't have to wait when testing out new filters.

In this example we will use the [Json Placeholder Api](https://jsonplaceholder.typicode.com/) with a time delay to demonstrate
loading and cached data.

The source code for this example can be found here: https://github.com/D-James-GH/cached_query/tree/main/examples/infinite_list

## The Setup

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
