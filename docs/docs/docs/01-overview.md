# Overview

Cached query is a collection of dart and flutter libraries inspired by tools such as SWR, React Query and RTKQuery from
the React world.

It helps reduce the pain and repetitiveness of caching and updating server data.

The Cached Query packages are:

- [Cached Query](https://pub.dev/packages/cached_query) - The core package with no flutter dependencies.
- 📱 [Cached Query Flutter](https://pub.dev/packages/cached_query_flutter) - Useful flutter additions, including
  connectivity status.
- 💽 [Cached Storage](https://pub.dev/packages/cached_storage) - an implementation of the CachedQuery StorageInterface
  using [sqflite](https://pub.dev/packages/sqflite).

## Features

- [Cached responses](/docs/guides/query)
- [ Infinite list caching ](/docs/guides/infinite-query)
- [Background fetching](/docs/flutter-additions)
- [Mutations](/docs/guides/mutations)
- [Persistent cache](/docs/storage) (flutter ios/android only, or easily create your own)
- [Can be used alongside state management options](/examples/with-flutter-bloc) (Bloc, Provider, etc...)
- [Re-fetch when connection is resumed](/docs/flutter-additions) (flutter only)
- [Re-fetch when app comes into the foreground ](/docs/flutter-additions)(flutter only)

## A Brief Overview Of How It Works...

All queries are stored in a global cache so that they are available anywhere in the project. When a query is
instantiated it will check the global cache for the specified key and either return a pre-existing query or
create a new one.

When the result of a query is requested it will always emit the currently stored value. If the data stored inside a
query is stale it will be re-fetched in the background.

This package uses darts built in streams to track the number of listeners attached to each query. Once a query has no
more listeners it will be removed from memory after a specific
[cache duration](/docs/guides/configuration#cache-duration).
