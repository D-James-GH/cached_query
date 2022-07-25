# Quick Start

This is just a brief example of using a `Query`.

```dart
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_storage/cached_storage.dart';
import 'package:flutter/material.dart';
import "my_api.dart" as api;

void main() async {
  // Optionally set global query defaults.
  CachedQuery.instance.configFlutter(
    storage: await CachedStorage.ensureInitialized(),
    config: const QueryConfig(),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final query = Query<String>(
      queryFn: api.fetchData,
      key: ["posts"],
    );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: QueryBuilder(
            query: query,
            builder: (context, state) => Column(
              children: [
                if (state.data != null) Text(state.data),
                if (state.status == QueryStatus.loading)
                  const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                if (state.status == QueryStatus.error)
                  const Text("An error occurred"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```
