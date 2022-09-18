# Observer
Any query, infinite query or mutation can be observed globally in one place. 

To set up an observer extend `QueryObserver` and set the observer on the cached query instance or as part of the config.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    ...config
    observer: Observer(),
  );
  runApp(const MyApp());
}
```
You can set the observer at any time.

```dart
CachedQuery.instance.observer = Observer();
```

To use an observer you must extend `QueryObserver`.
```dart
class Observer extends QueryObserver {
  @override
  void onChange(
      QueryBase<dynamic, dynamic> query,
      QueryState<dynamic> nextState,
      ) {
    debugPrint(nextState.status.toString());
    super.onChange(query, nextState);
  }
}
```
There are a few different methods that you can override: 
- `onQueryCreation` - When a query or infinite query is added to cache. This will only fire once in a lifetime of a query. 
- `onQueryDeletion` - When a query or infinite query is deleted from cache. 
- `onChange` - When the state of a query or infinite query is changed.
- `onError` - When and error occurs in an infinite query or query.
- `onMutationCreation` - When a mutation is created. 
- `onMutationChange` - When the state of a mutation changes.
- `onMutationError` - When an error occurs in a mutation. 

