## 0.5.0+1

 - **DOCS**: update docs for the depreciation of updateInfiniteQuery. ([9fa99ef6](https://github.com/D-James-GH/cached_query/commit/9fa99ef62735e512d5b24c4beb05fa7f23481c4d))

## 0.5.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: combine updateInfiniteQuery and updateQuery in the global CachedQuery object. ([e8fd8602](https://github.com/D-James-GH/cached_query/commit/e8fd86029af9cebc9f06f0d20e432865a02db69e))

## 0.4.0+1

 - **DOCS**: update to query config flutter. ([2b729f49](https://github.com/D-James-GH/cached_query/commit/2b729f49a13864abb3d4f2bffadb0fdce2297fb0))

## 0.4.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: allow refetch config per query. QueryConfig can no longer be const.

## 0.3.1+4

 - **DOCS**: correction to api docs and infinite query example.

## 0.3.1+3

 - **FIX**: update rxdart.

## 0.3.1+1

 - **DOCS**: added observer and side effect docs.

## 0.3.1

 - **FEAT**: add creation and deletion observers.

## 0.3.0+1

 - **FIX**: export query observer.

## 0.3.0

> Note: This release has breaking changes.

 - **FEAT**: initial commit.
 - **FEAT**: add observer.
 - **BREAKING** **FEAT**: remove isFetching from mutation, use status == QueryStatus.loading. This brings it into line with query and infinite query.

## 0.2.1

 - **FEAT**: add query and infinite query onSuccess and onError callbacks.
 - **DOCS**: update builder docs to include querykey.

## 0.2.0

> Note: This release has breaking changes.

 - **DOCS**: update spacing.
 - **BREAKING** **FEAT**: reset infinite query data if first pages aren't equal, option to turn off.

## 0.1.1

 - **FEAT**: add a fallback to onError.

## 0.1.0+2

 - **DOCS**: Readmes updated to show documentation link.

## 0.1.0+1

 - **FIX**: Infinite query doesn't fetch all pages from storage.

## 0.1.0

 - Bump "cached_query" to `0.1.0`.

## 0.1.0

 - **FIX**: Infinite query not re-fetching in order.
 - **FIX**: try to get result each time a stream is requested.
 - **FIX**: seeded the stream with the current state.
 - **DOCS**: docusaurus and query page.
 - **DOCS**: initial commit.
 - **DOCS**: update contents.
 - **DOCS**: add links to readme.
 - **DOCS**: error handling.

## 0.0.3
docs: better readme layout

## 0.0.2 
* fix: try to fetch anytime the stream is requested

## 0.0.2-dev.2
* fix: seeded query stream with current state.

## 0.0.2-dev.1

* Remove the unnecessary dependency on flutter

## 0.0.1

* Cached query, a simple library for dealing with server state in dart and flutter.