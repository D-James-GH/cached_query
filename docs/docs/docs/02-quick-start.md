# Quick Start

## Installation

For a dart only product install the base package:

```
dependencies:
  cached_query: ^[version]
```

For flutter projects:

```
dependencies:
  cached_query_flutter: ^[version]
```

## Basic Usage

This code snippet showcases the use of a [Query](/docs/guides/query), [offline persistence](/docs/flutter-additions) and [configuration](/docs/guides/configuration).

```dart
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_storage/cached_storage.dart';
import 'package:flutter/material.dart';
import "my_api.dart" as api;

void main() async {
  // Optionally set global query defaults.
  CachedQuery.instance.configFlutter(
    // Initialize Cached Storage to persist the cache to disk
    storage: await CachedStorage.ensureInitialized(),
    config: const QueryConfig(
      // Globally set the refetch duration
      refetchDuration: Duration(seconds: 4),
    ),
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
      key: ["title"],
    );
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
