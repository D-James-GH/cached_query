## 3.0.0-dev.12

 - **FEAT**: added convenience methods to infinite query data. ([fec46348](https://github.com/D-James-GH/cached_query/commit/fec4634852ba92cb86904fd47d4ecfa7cd568a87))

## 3.0.0-dev.11

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: merge QueryBase and Cacheable so queries only extend one sealed class. ([33d8566d](https://github.com/D-James-GH/cached_query/commit/33d8566dca472e236019de34110945a03eab3cd1))

## 3.0.0-dev.10

> Note: This release has breaking changes.

 - **FIX**: observer not supported in new architecture. Multiple fixes for tests. ([5716dd84](https://github.com/D-James-GH/cached_query/commit/5716dd84b555636488dd481f09ddbd5850b3ab60))
 - **FIX**: use initial fetch flag inside fetch. ([74cdd2ab](https://github.com/D-James-GH/cached_query/commit/74cdd2abc547f40980c7e06e58553f10790c3d92))
 - **BREAKING** **REFACTOR**: Have different global and query config objects. ([ec9cae10](https://github.com/D-James-GH/cached_query/commit/ec9cae10b48e4f32e2421cd094b0b814d127e897))

## 3.0.0-dev.9

> Note: This release has breaking changes.

 - **REFACTOR**: add equlaity to stored query. ([2c4eaa12](https://github.com/D-James-GH/cached_query/commit/2c4eaa1272bd881a9f98ed155de319ccfe0b95b0))
 - **BREAKING** **REFACTOR**: Rename QueryBase to QueryController. QueryBase is now just a sealed class extended by Query and InfiniteQuery. This is to allow for more specific typing of QueryController if needed without requiring observers to change. ([5dfc7611](https://github.com/D-James-GH/cached_query/commit/5dfc7611c99bb33d459d75e1716d8859fbe9560c))

## 3.0.0-dev.8

 - **REFACTOR**: remove mocks in cached query tests. ([bad90bfb](https://github.com/D-James-GH/cached_query/commit/bad90bfb007a6b3964f353ca7bd106974ea8a4c6))

## 3.0.0-dev.7

 - **REFACTOR**: move more core logic to query base. ([3a266f79](https://github.com/D-James-GH/cached_query/commit/3a266f79d00e02c79055d7ff3f2ea5e84b9031ad))

## 3.0.0-dev.6

 - **FEAT**: query success data is now just the type T not T?, data can still be nullable by passing T? as the generic. ([ba5e2b74](https://github.com/D-James-GH/cached_query/commit/ba5e2b74d75a9a743d2492f26e927f592dd83db4))

## 3.0.0-dev.5

 - **FEAT**: add isInitialFetch to loading state. ([c3799a95](https://github.com/D-James-GH/cached_query/commit/c3799a95287804a84e2c89f309964c26bc0addfa))

## 3.0.0-dev.4

 - **FIX**: change page params in infinite query to not nullable. ([c95b6cd1](https://github.com/D-James-GH/cached_query/commit/c95b6cd1a9739614994aa2ca5b5470a5d3409c8d))

## 3.0.0-dev.3

 - **FEAT**: invalidating a query will, by default, refetch active queries. ([d63579f5](https://github.com/D-James-GH/cached_query/commit/d63579f57b73442ccafcb9b3f94188a85e95198d))

## 3.0.0-dev.2

> Note: This release has breaking changes.

 - **REFACTOR**: remove unnecessary infinite query fetch params. ([0304a6c3](https://github.com/D-James-GH/cached_query/commit/0304a6c3dd801af02a842ca832cba54abe19fdb3))
 - **REFACTOR**: infinite query ready for direction. ([fabc2476](https://github.com/D-James-GH/cached_query/commit/fabc2476271b7d007d0811f276bbba04d640a2ad))
 - **REFACTOR**: infinite query ready for direction. ([4b456a0c](https://github.com/D-James-GH/cached_query/commit/4b456a0c9a34e5ca530b90c57907588abd327420))
 - **FIX**: infinite query not fetching from storage. ([2369dc3e](https://github.com/D-James-GH/cached_query/commit/2369dc3e886375d40878cfea0cec46213c9be877))
 - **FIX**: after rebasing 2.6. ([378858f9](https://github.com/D-James-GH/cached_query/commit/378858f9b0c62c9fd271d250b155b0f8f138156d))
 - **FIX**: add missed part. ([8b996510](https://github.com/D-James-GH/cached_query/commit/8b99651041571cbbb2a59609010dbc08ff1de8fa))
 - **FIX**: add missed part. ([a137276d](https://github.com/D-James-GH/cached_query/commit/a137276daf213cf1de9c29e98b78a57f930177b8))
 - **FEAT**: update devtools for 3. ([f462df2b](https://github.com/D-James-GH/cached_query/commit/f462df2b5df460dfa47d41a576aa32af7feee5d9))
 - **FEAT**: add emit to setstate. ([5a7e2340](https://github.com/D-James-GH/cached_query/commit/5a7e2340bed4facc8178a0cd5b57b962a4d70477))
 - **FEAT**: update devtools for 3. ([352c43b4](https://github.com/D-James-GH/cached_query/commit/352c43b47e46bd6119ba4979508ed6715099a298))
 - **FEAT**: add emit to setstate. ([990aff6e](https://github.com/D-James-GH/cached_query/commit/990aff6e3a054ef0d0f33527559191bbceb0f4cc))
 - **BREAKING** **FEAT**: change state to sealed classes. ([3f4030d4](https://github.com/D-James-GH/cached_query/commit/3f4030d4d3234cd4da1ee33a3305181c6f2ae6c1))
 - **BREAKING** **FEAT**: remove deprecated things. ([f238b9fc](https://github.com/D-James-GH/cached_query/commit/f238b9fc3b75d30142dac77aa43515f5c72afae0))
 - **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([e35c614b](https://github.com/D-James-GH/cached_query/commit/e35c614b0f38fa213aee1bc6e01995bcd147ebf3))
 - **BREAKING** **FEAT**: change state to sealed classes. ([dcabfd41](https://github.com/D-James-GH/cached_query/commit/dcabfd416f23af4768d028b310c36e61ed51d792))
 - **BREAKING** **FEAT**: remove deprecated things. ([3e68942b](https://github.com/D-James-GH/cached_query/commit/3e68942bf10cd095b9fb7dc3fda4d7fdff08eb58))
 - **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([ff284686](https://github.com/D-James-GH/cached_query/commit/ff2846860c379fa7927066bb3c30ef29dd1ff052))

## 3.0.0-dev.1

 - **FEAT**: update devtools for 3. ([352c43b4](https://github.com/D-James-GH/cached_query/commit/352c43b47e46bd6119ba4979508ed6715099a298))

## 3.0.0-dev.0

> Note: This release has breaking changes.

 - **REFACTOR**: infinite query ready for direction. ([4b456a0c](https://github.com/D-James-GH/cached_query/commit/4b456a0c9a34e5ca530b90c57907588abd327420))
 - **FIX**: add missed part. ([a137276d](https://github.com/D-James-GH/cached_query/commit/a137276daf213cf1de9c29e98b78a57f930177b8))
 - **FEAT**: add emit to setstate. ([990aff6e](https://github.com/D-James-GH/cached_query/commit/990aff6e3a054ef0d0f33527559191bbceb0f4cc))
 - **BREAKING** **FEAT**: change state to sealed classes. ([dcabfd41](https://github.com/D-James-GH/cached_query/commit/dcabfd416f23af4768d028b310c36e61ed51d792))
 - **BREAKING** **FEAT**: remove deprecated things. ([3e68942b](https://github.com/D-James-GH/cached_query/commit/3e68942bf10cd095b9fb7dc3fda4d7fdff08eb58))
 - **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([ff284686](https://github.com/D-James-GH/cached_query/commit/ff2846860c379fa7927066bb3c30ef29dd1ff052))

## 2.2.0

 - **FEAT**: change CachedQuery.instance.refetchQueries() to a future. ([047edffe](https://github.com/D-James-GH/cached_query/commit/047edffe3ce9ea6e84e101f347d5677ddc34aa39))

## 2.1.4

 - **FIX**: manual query update > local storage & web platform check ([#55](https://github.com/D-James-GH/cached_query/issues/55)). ([1a1ac507](https://github.com/D-James-GH/cached_query/commit/1a1ac507c116f101f498a89b58c52f8ebde98134))

## 2.1.3

 - **FIX**: ignore deprecated warning for hasReachedMax. ([efbaa5c4](https://github.com/D-James-GH/cached_query/commit/efbaa5c4d9e8830d393933344520496ac12c67e5))

## 2.1.2

 - **REFACTOR**: depriciate hasreachedmax on infinite query state. ([3231390e](https://github.com/D-James-GH/cached_query/commit/3231390e5bf2f9d5f53da0ec6914728851754d70))

## 2.1.1

 - **FIX**: typing improvements. ([c45c8f52](https://github.com/D-James-GH/cached_query/commit/c45c8f52741097b3c3ad7f6092df178f946e7154))

## 2.1.0

 - **FEAT**: allow multiple caches in flutter. ([4429f6fe](https://github.com/D-James-GH/cached_query/commit/4429f6fef7077eed926f6ed1c2c0112846b2fe96))
 - **FEAT**: allow passing a different cache to queries. ([aeb23396](https://github.com/D-James-GH/cached_query/commit/aeb23396b13346df45d47a7cd7b76ef4d7f51a89))

## 2.0.7

 - **FIX**: keep time stamp if updating manually. ([1655444e](https://github.com/D-James-GH/cached_query/commit/1655444e74dd77ba2eabdc6a800688ec118d2868))

## 2.0.6

 - **FIX**: allow updating state to null. ([c0753854](https://github.com/D-James-GH/cached_query/commit/c0753854244e22f3ea2a32b90f2627a9c8ebef40))

## 2.0.5

 - **REFACTOR**: infinite_query. ([f7d1708b](https://github.com/D-James-GH/cached_query/commit/f7d1708bbb4dcdd2822a118970fd6c3a38ce4f80))
 - **FIX**: upgrade rx dart to 0.28.*. ([2fbcf5c3](https://github.com/D-James-GH/cached_query/commit/2fbcf5c321928d8b49c6e6985e2bfeec98c3f846))

## 2.0.4

 - **FIX**: infinite query getting stuck if it has max and the first page is different. ([ce49d295](https://github.com/D-James-GH/cached_query/commit/ce49d295e197e9d6f540d68fd9931b7f532764ee))

## 2.0.3

 - **FIX**: add reset of _currentFuture with whenComplete handler ([#35](https://github.com/D-James-GH/cached_query/issues/35)). ([bf75ef0b](https://github.com/D-James-GH/cached_query/commit/bf75ef0b459107211ddef0991fd93321fdff0e75))

## 2.0.2

 - **FIX**: deps update for flutter 3.22 ([#31](https://github.com/D-James-GH/cached_query/issues/31)). ([1fbc044b](https://github.com/D-James-GH/cached_query/commit/1fbc044b7b925066cd4101dc2eefd14c10e801aa))

## 2.0.1

 - **FIX**: devtools not building. ([03306c4b](https://github.com/D-James-GH/cached_query/commit/03306c4bb56d7e2cea4367cabb3adb9a39e1dd64))

## 2.0.0

 - Release 2.0.0
 - **FIX**: lints. ([d3677368](https://github.com/D-James-GH/cached_query/commit/d3677368d916e349e50e35e118b7dce4f8619c42))
 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 2.0.0-dev.3

 - **FEAT**: add devtools. ([ef621f1f](https://github.com/D-James-GH/cached_query/commit/ef621f1f8a4830d75c9d0cdd2b6b40e9efa8a7cf))
 - **DOCS**: add devtools extension. ([3464c736](https://github.com/D-James-GH/cached_query/commit/3464c736f5c7383ea9eafbaf266937ddbe163078))

## 2.0.0-dev.2

 - **FEAT**: add devtools package ([#24](https://github.com/D-James-GH/cached_query/issues/24)). ([43ba85ea](https://github.com/D-James-GH/cached_query/commit/43ba85ea3c65debd006a457dfef6aadf9130ef3b))
 - **FEAT**: added shouldRefetch call back to the query config. ([#21](https://github.com/D-James-GH/cached_query/issues/21)). ([3e944b64](https://github.com/D-James-GH/cached_query/commit/3e944b64c387487d7315d224759161763c28ccc3))
 - **DOCS**: update for storageSerializer and storageDeserializer. ([0b4c4e5f](https://github.com/D-James-GH/cached_query/commit/0b4c4e5fb4a5e005d8e21e48e2ff748036065b47))

## 2.0.0-dev.1

 - **FEAT**: added storageSerializer and storageDeserializer to the QueryConfig to allow for more flexible storage ([#20](https://github.com/D-James-GH/cached_query/issues/20)). ([4aca144d](https://github.com/D-James-GH/cached_query/commit/4aca144dd49589309d49969f9f11ce42eeff87ce))
 - **DOCS**: add change for breaking change. ([67711026](https://github.com/D-James-GH/cached_query/commit/67711026e648dfec1d0f72c90601ffeddb355070))

## 2.0.0-dev.0

> Note: This release has breaking changes.

 - **FEAT**: added query logging observer. ([a95896e7](https://github.com/D-James-GH/cached_query/commit/a95896e78e661ac19abf47794253d287e4d9878e))
 - **BREAKING** **FEAT**: Allow multiple observers to be added. ([a95896e7](https://github.com/D-James-GH/cached_query/commit/a95896e78e661ac19abf47794253d287e4d9878e))
 - **FEAT**: switch mutation to use behaviour subject. ([3e50021a](https://github.com/D-James-GH/cached_query/commit/3e50021a19a6ed44d5757d973c5efddca34f10ce))
 - **BREAKING** **FEAT**: return mutation state from mutate function. ([02e29ed0](https://github.com/D-James-GH/cached_query/commit/02e29ed0f5aa53ec874df5468fabe783c7ccc0f0))

## 1.0.1

 - **FIX**: analysis options, for examples. ([0f28d977](https://github.com/D-James-GH/cached_query/commit/0f28d97775c78f9c6972fbd0bd9aee9d13446e7e))
 - **FIX**: package updates. ([0a934e2f](https://github.com/D-James-GH/cached_query/commit/0a934e2f5c99231e9d3644a40dae8d52bca5f814))
 - **FIX**: better generic type names. ([1e7fb516](https://github.com/D-James-GH/cached_query/commit/1e7fb5165cbc1fb864b7dc61a41d38ab35cd8fc6))

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-dev.1

## 0.6.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: add filterFn to CachedQuery.instance.refetchQueries(). ([1d452bba](https://github.com/D-James-GH/cached_query/commit/1d452bba691a112be92b5658fbf6c30b628e78d2))

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