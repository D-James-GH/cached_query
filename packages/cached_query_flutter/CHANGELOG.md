## 3.3.0

 - **FEAT**: add polling interval config. ([fe9e8384](https://github.com/D-James-GH/cached_query/commit/fe9e8384774719ea669ad8e922e84c07e83cb775))

## 3.2.0

 - **FEAT**: setQueryData creates a query if non exists. ([07c38e29](https://github.com/D-James-GH/cached_query/commit/07c38e297c636634b6df6cf9c83a733541ba2457))

## 3.1.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 3.1.0-dev.0

 - **FEAT**: allow for changing of config by having multiple queries attaching to one controller ([#88](https://github.com/D-James-GH/cached_query/issues/88)). ([fecf0f4a](https://github.com/D-James-GH/cached_query/commit/fecf0f4a2ed53460bf70b8da64044cecac994c9b))

## 3.0.4

 - **FIX**: update connectivity dep. ([d61dc4b6](https://github.com/D-James-GH/cached_query/commit/d61dc4b6350f9802fb1d21de7683eec6d908d501))

## 3.0.3

 - Update a dependency to the latest release.

## 3.0.2

 - **FIX**: Check if query has active listeners before refetching on resume or connection ([#86](https://github.com/D-James-GH/cached_query/issues/86)). ([b09ab4c6](https://github.com/D-James-GH/cached_query/commit/b09ab4c65055f9dfe41dbf9cb6fef920aed24825))

## 3.0.1

 - **FIX**: errors for version 3 in readme. ([4b6029ca](https://github.com/D-James-GH/cached_query/commit/4b6029caaeb9f8ac4683d97d13be0442b4bac997))

## 3.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 3.0.0-dev.19

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: make refetchDuration staleDuration for more clarity. ([e52d72fa](https://github.com/D-James-GH/cached_query/commit/e52d72fa80b86842aa207a7d42781d395a540ba5))

## 3.0.0-dev.18

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: change name of mutation funciton to mutationFn for clarity. ([f91ed15d](https://github.com/D-James-GH/cached_query/commit/f91ed15db13e22a5fa105478a3d76e89985f2ac4))

## 3.0.0-dev.17

> Note: This release has breaking changes.

 - **REFACTOR**: remove mocks in cached query tests. ([5e4f480b](https://github.com/D-James-GH/cached_query/commit/5e4f480b8917ab2449412fc4f89c1f1e740f328e))
 - **REFACTOR**: remove mocks in cached query tests. ([bad90bfb](https://github.com/D-James-GH/cached_query/commit/bad90bfb007a6b3964f353ca7bd106974ea8a4c6))
 - **FIX**: observer not supported in new architecture. Multiple fixes for tests. ([2975288c](https://github.com/D-James-GH/cached_query/commit/2975288c02560e757d857b47c6dca4c37b3d024d))
 - **FIX**: broken test. ([0ff238d2](https://github.com/D-James-GH/cached_query/commit/0ff238d2bf2a05ad88550ac15c1df30dc3cdfb96))
 - **FIX**: after rebasing 2.6. ([2f35ddd5](https://github.com/D-James-GH/cached_query/commit/2f35ddd50b3f22cab456fff300ffb24e61571089))
 - **FIX**: observer not supported in new architecture. Multiple fixes for tests. ([5716dd84](https://github.com/D-James-GH/cached_query/commit/5716dd84b555636488dd481f09ddbd5850b3ab60))
 - **FIX**: broken test. ([84c885c3](https://github.com/D-James-GH/cached_query/commit/84c885c3bd017fc34d940ed40c7cc6c3455317a7))
 - **FIX**: after rebasing 2.6. ([378858f9](https://github.com/D-James-GH/cached_query/commit/378858f9b0c62c9fd271d250b155b0f8f138156d))
 - **FEAT**: expose check connection. ([342aa0a4](https://github.com/D-James-GH/cached_query/commit/342aa0a4be5a0db9c748269972c94b30945a1b5d))
 - **FEAT**: expose the connetion state for flutter apps. ([e0c7bff3](https://github.com/D-James-GH/cached_query/commit/e0c7bff332d1fb29de10d405b2dfbe12e6f4f07a))
 - **FEAT**: invalidating a query will, by default, refetch active queries. ([e84067fe](https://github.com/D-James-GH/cached_query/commit/e84067fe624637abf1fdba32532afb0b09bd9e45))
 - **FEAT**: update devtools for 3. ([a888bba3](https://github.com/D-James-GH/cached_query/commit/a888bba38618547f005b0dc4683f5a418e7003c6))
 - **FEAT**: expose check connection. ([3e8f6bbf](https://github.com/D-James-GH/cached_query/commit/3e8f6bbff701ee70ad2815c7457a0ddb1477040c))
 - **FEAT**: expose the connetion state for flutter apps. ([334f25c9](https://github.com/D-James-GH/cached_query/commit/334f25c92d4a332a7c6fb01b9c3be858b3660bda))
 - **FEAT**: invalidating a query will, by default, refetch active queries. ([d63579f5](https://github.com/D-James-GH/cached_query/commit/d63579f57b73442ccafcb9b3f94188a85e95198d))
 - **FEAT**: update devtools for 3. ([f462df2b](https://github.com/D-James-GH/cached_query/commit/f462df2b5df460dfa47d41a576aa32af7feee5d9))
 - **BREAKING** **REFACTOR**: change type params of get query to a query rather than state. ([1ad59615](https://github.com/D-James-GH/cached_query/commit/1ad59615a106c2f3fc0b2a1f5b3ce294bbd70d3a))
 - **BREAKING** **REFACTOR**: merge QueryBase and Cacheable so queries only extend one sealed class. ([fddddeb9](https://github.com/D-James-GH/cached_query/commit/fddddeb912839df27fc77171af6851469e734a40))
 - **BREAKING** **REFACTOR**: Have different global and query config objects. ([736c310b](https://github.com/D-James-GH/cached_query/commit/736c310b1c8fcb1d0d393667e4cc2d1e6b6effb0))
 - **BREAKING** **REFACTOR**: Rename QueryBase to QueryController. QueryBase is now just a sealed class extended by Query and InfiniteQuery. This is to allow for more specific typing of QueryController if needed without requiring observers to change. ([52631c6d](https://github.com/D-James-GH/cached_query/commit/52631c6d1e2d40216161b255e64b31cc751bec01))
 - **BREAKING** **REFACTOR**: change type params of get query to a query rather than state. ([f62e5eec](https://github.com/D-James-GH/cached_query/commit/f62e5eec0160345714c2b26b7a07654d1eac5654))
 - **BREAKING** **REFACTOR**: merge QueryBase and Cacheable so queries only extend one sealed class. ([33d8566d](https://github.com/D-James-GH/cached_query/commit/33d8566dca472e236019de34110945a03eab3cd1))
 - **BREAKING** **REFACTOR**: Have different global and query config objects. ([ec9cae10](https://github.com/D-James-GH/cached_query/commit/ec9cae10b48e4f32e2421cd094b0b814d127e897))
 - **BREAKING** **REFACTOR**: Rename QueryBase to QueryController. QueryBase is now just a sealed class extended by Query and InfiniteQuery. This is to allow for more specific typing of QueryController if needed without requiring observers to change. ([5dfc7611](https://github.com/D-James-GH/cached_query/commit/5dfc7611c99bb33d459d75e1716d8859fbe9560c))
 - **BREAKING** **FEAT**: change state to sealed classes. ([add9b594](https://github.com/D-James-GH/cached_query/commit/add9b59414e7b3f9fad90d54bc1e4f49aafcbcd4))
 - **BREAKING** **FEAT**: Merge infinite query builder and query builder so that they function the same. Deprecated InfiniteQueryBuilder. ([6f8820ff](https://github.com/D-James-GH/cached_query/commit/6f8820ff0df40ee62c3ae0d01d3b04c1fdd94de3))
 - **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([df9886d9](https://github.com/D-James-GH/cached_query/commit/df9886d98d15a5054434844684bbeb57644b9e19))
 - **BREAKING** **FEAT**: change state to sealed classes. ([3f4030d4](https://github.com/D-James-GH/cached_query/commit/3f4030d4d3234cd4da1ee33a3305181c6f2ae6c1))
 - **BREAKING** **FEAT**: Merge infinite query builder and query builder so that they function the same. Deprecated InfiniteQueryBuilder. ([f4b14485](https://github.com/D-James-GH/cached_query/commit/f4b144858a7ddcc95249fcae433e0157a1a614c4))
 - **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([e35c614b](https://github.com/D-James-GH/cached_query/commit/e35c614b0f38fa213aee1bc6e01995bcd147ebf3))

## 3.0.0-dev.16

 - Update a dependency to the latest release.

## 3.0.0-dev.15

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: change type params of get query to a query rather than state. ([f62e5eec](https://github.com/D-James-GH/cached_query/commit/f62e5eec0160345714c2b26b7a07654d1eac5654))

## 3.0.0-dev.14

 - **FEAT**: expose check connection. ([3e8f6bbf](https://github.com/D-James-GH/cached_query/commit/3e8f6bbff701ee70ad2815c7457a0ddb1477040c))

## 3.0.0-dev.13

 - Update a dependency to the latest release.

## 3.0.0-dev.12

 - Update a dependency to the latest release.

## 3.0.0-dev.11

> Note: This release has breaking changes.

 - **FEAT**: expose the connetion state for flutter apps. ([334f25c9](https://github.com/D-James-GH/cached_query/commit/334f25c92d4a332a7c6fb01b9c3be858b3660bda))
 - **BREAKING** **REFACTOR**: merge QueryBase and Cacheable so queries only extend one sealed class. ([33d8566d](https://github.com/D-James-GH/cached_query/commit/33d8566dca472e236019de34110945a03eab3cd1))

## 3.0.0-dev.10

> Note: This release has breaking changes.

 - **FIX**: observer not supported in new architecture. Multiple fixes for tests. ([5716dd84](https://github.com/D-James-GH/cached_query/commit/5716dd84b555636488dd481f09ddbd5850b3ab60))
 - **BREAKING** **REFACTOR**: Have different global and query config objects. ([ec9cae10](https://github.com/D-James-GH/cached_query/commit/ec9cae10b48e4f32e2421cd094b0b814d127e897))

## 3.0.0-dev.9

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: Rename QueryBase to QueryController. QueryBase is now just a sealed class extended by Query and InfiniteQuery. This is to allow for more specific typing of QueryController if needed without requiring observers to change. ([5dfc7611](https://github.com/D-James-GH/cached_query/commit/5dfc7611c99bb33d459d75e1716d8859fbe9560c))

## 3.0.0-dev.8

 - **REFACTOR**: remove mocks in cached query tests. ([bad90bfb](https://github.com/D-James-GH/cached_query/commit/bad90bfb007a6b3964f353ca7bd106974ea8a4c6))

## 3.0.0-dev.7

 - Update a dependency to the latest release.

## 3.0.0-dev.6

 - **FIX**: broken test. ([84c885c3](https://github.com/D-James-GH/cached_query/commit/84c885c3bd017fc34d940ed40c7cc6c3455317a7))

## 3.0.0-dev.5

 - Update a dependency to the latest release.

## 3.0.0-dev.4

 - Update a dependency to the latest release.

## 3.0.0-dev.3

 - **FEAT**: invalidating a query will, by default, refetch active queries. ([d63579f5](https://github.com/D-James-GH/cached_query/commit/d63579f57b73442ccafcb9b3f94188a85e95198d))

## 3.0.0-dev.2

> Note: This release has breaking changes.

 - **FIX**: after rebasing 2.6. ([378858f9](https://github.com/D-James-GH/cached_query/commit/378858f9b0c62c9fd271d250b155b0f8f138156d))
 - **FEAT**: update devtools for 3. ([f462df2b](https://github.com/D-James-GH/cached_query/commit/f462df2b5df460dfa47d41a576aa32af7feee5d9))
 - **FEAT**: Applies shouldRefetch config to refetchCurrentQueries ([#64](https://github.com/D-James-GH/cached_query/issues/64)). ([7787bcde](https://github.com/D-James-GH/cached_query/commit/7787bcde9f0b2412b847d084f638246783395291))
 - **FEAT**: update devtools for 3. ([352c43b4](https://github.com/D-James-GH/cached_query/commit/352c43b47e46bd6119ba4979508ed6715099a298))
 - **BREAKING** **FEAT**: change state to sealed classes. ([3f4030d4](https://github.com/D-James-GH/cached_query/commit/3f4030d4d3234cd4da1ee33a3305181c6f2ae6c1))
 - **BREAKING** **FEAT**: Merge infinite query builder and query builder so that they function the same. Deprecated InfiniteQueryBuilder. ([f4b14485](https://github.com/D-James-GH/cached_query/commit/f4b144858a7ddcc95249fcae433e0157a1a614c4))
 - **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([e35c614b](https://github.com/D-James-GH/cached_query/commit/e35c614b0f38fa213aee1bc6e01995bcd147ebf3))
 - **BREAKING** **FEAT**: change state to sealed classes. ([dcabfd41](https://github.com/D-James-GH/cached_query/commit/dcabfd416f23af4768d028b310c36e61ed51d792))
 - **BREAKING** **FEAT**: Merge infinite query builder and query builder so that they function the same. Deprecated InfiniteQueryBuilder. ([5c687e76](https://github.com/D-James-GH/cached_query/commit/5c687e7630bb1edfc5abf9fcdf14d0d97d49fad3))
 - **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([ff284686](https://github.com/D-James-GH/cached_query/commit/ff2846860c379fa7927066bb3c30ef29dd1ff052))

## 3.0.0-dev.1

 - **FEAT**: update devtools for 3. ([352c43b4](https://github.com/D-James-GH/cached_query/commit/352c43b47e46bd6119ba4979508ed6715099a298))

## 3.0.0-dev.0

> Note: This release has breaking changes.

- **BREAKING** **FEAT**: change state to sealed classes. ([dcabfd41](https://github.com/D-James-GH/cached_query/commit/dcabfd416f23af4768d028b310c36e61ed51d792))
- **BREAKING** **FEAT**: Merge infinite query builder and query builder so that they function the same. Deprecated InfiniteQueryBuilder. ([5c687e76](https://github.com/D-James-GH/cached_query/commit/5c687e7630bb1edfc5abf9fcdf14d0d97d49fad3))
- **BREAKING** **FEAT**: update env to 3.0.0+ and fix lints. ([ff284686](https://github.com/D-James-GH/cached_query/commit/ff2846860c379fa7927066bb3c30ef29dd1ff052))

## 2.6.0

 - **FEAT**: Applies shouldRefetch config to refetchCurrentQueries ([#64](https://github.com/D-James-GH/cached_query/issues/64)). ([7787bcde](https://github.com/D-James-GH/cached_query/commit/7787bcde9f0b2412b847d084f638246783395291))

## 2.5.0

 - **FEAT**: change CachedQuery.instance.refetchQueries() to a future. ([047edffe](https://github.com/D-James-GH/cached_query/commit/047edffe3ce9ea6e84e101f347d5677ddc34aa39))

## 2.4.4

 - **REFACTOR**: package update. ([22944de7](https://github.com/D-James-GH/cached_query/commit/22944de756865c7e77138a372fd20489ebae5519))
 - **FIX**: manual query update > local storage & web platform check ([#55](https://github.com/D-James-GH/cached_query/issues/55)). ([1a1ac507](https://github.com/D-James-GH/cached_query/commit/1a1ac507c116f101f498a89b58c52f8ebde98134))

## 2.4.3

 - **REFACTOR**: package update. ([22944de7](https://github.com/D-James-GH/cached_query/commit/22944de756865c7e77138a372fd20489ebae5519))

## 2.4.2

 - Update a dependency to the latest release.

## 2.4.1

 - Update a dependency to the latest release.

## 2.4.0

 - **FEAT**: added background duration to fetchOnResume ([#52](https://github.com/D-James-GH/cached_query/issues/52)). ([1e71c9b2](https://github.com/D-James-GH/cached_query/commit/1e71c9b28fa9517525389193321002db73db9395))

## 2.3.0

 - **FEAT**: allow multiple caches in flutter. ([4429f6fe](https://github.com/D-James-GH/cached_query/commit/4429f6fef7077eed926f6ed1c2c0112846b2fe96))
 - **FEAT**: allow passing a different cache to queries. ([aeb23396](https://github.com/D-James-GH/cached_query/commit/aeb23396b13346df45d47a7cd7b76ef4d7f51a89))

## 2.2.0

 - **FEAT**: add enabled flag to consumer and listener. ([4c340484](https://github.com/D-James-GH/cached_query/commit/4c34048411565495dd891b0928edd9e2a7de9315))
 - **FEAT**: add enable flag to infinite query builder. ([a415d847](https://github.com/D-James-GH/cached_query/commit/a415d847d367af38be653e2754aba6bb491f67dc))
 - **FEAT**: add enabled flag to query_builder.dart. ([d8de7b6f](https://github.com/D-James-GH/cached_query/commit/d8de7b6fc1837153c73f0c0a74ffdc0d128aae4b))

## 2.1.4

 - Update a dependency to the latest release.

## 2.1.3

 - Update a dependency to the latest release.

## 2.1.2

 - **REFACTOR**: infinite_query. ([f7d1708b](https://github.com/D-James-GH/cached_query/commit/f7d1708bbb4dcdd2822a118970fd6c3a38ce4f80))
 - **FIX**: upgrade rx dart to 0.28.*. ([2fbcf5c3](https://github.com/D-James-GH/cached_query/commit/2fbcf5c321928d8b49c6e6985e2bfeec98c3f846))

## 2.1.1

 - Update a dependency to the latest release.

## 2.1.0

 - **FEAT**: listener and consumer widgets ([#36](https://github.com/D-James-GH/cached_query/issues/36)). ([01595f4a](https://github.com/D-James-GH/cached_query/commit/01595f4a225e708587f78b14b05d33e6d6fdc336))

## 2.0.3

 - Update a dependency to the latest release.

## 2.0.2

 - **FIX**: deps update for flutter 3.22 ([#31](https://github.com/D-James-GH/cached_query/issues/31)). ([1fbc044b](https://github.com/D-James-GH/cached_query/commit/1fbc044b7b925066cd4101dc2eefd14c10e801aa))

## 2.0.1

 - Update a dependency to the latest release.

## 2.0.0

 - Release 2.0.0
 - **FIX**: lints. ([d3677368](https://github.com/D-James-GH/cached_query/commit/d3677368d916e349e50e35e118b7dce4f8619c42))
 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 2.0.0-dev.3

 - **FEAT**: add devtools. ([ef621f1f](https://github.com/D-James-GH/cached_query/commit/ef621f1f8a4830d75c9d0cdd2b6b40e9efa8a7cf))

## 2.0.0-dev.2

 - **FEAT**: add devtools package ([#24](https://github.com/D-James-GH/cached_query/issues/24)). ([43ba85ea](https://github.com/D-James-GH/cached_query/commit/43ba85ea3c65debd006a457dfef6aadf9130ef3b))
 - **DOCS**: update for storageSerializer and storageDeserializer. ([0b4c4e5f](https://github.com/D-James-GH/cached_query/commit/0b4c4e5fb4a5e005d8e21e48e2ff748036065b47))

## 2.0.0-dev.1

 - **FEAT**: added storageSerializer and storageDeserializer to the QueryConfig to allow for more flexible storage ([#20](https://github.com/D-James-GH/cached_query/issues/20)). ([4aca144d](https://github.com/D-James-GH/cached_query/commit/4aca144dd49589309d49969f9f11ce42eeff87ce))

## 2.0.0-dev.0

> Note: This release has breaking changes.

 - **FEAT**: added query logging observer. ([a95896e7](https://github.com/D-James-GH/cached_query/commit/a95896e78e661ac19abf47794253d287e4d9878e))
 - **BREAKING** **FEAT**: return mutation state from mutate function. ([02e29ed0](https://github.com/D-James-GH/cached_query/commit/02e29ed0f5aa53ec874df5468fabe783c7ccc0f0))

## 1.0.1

 - **FIX**: analysis options, for examples. ([0f28d977](https://github.com/D-James-GH/cached_query/commit/0f28d97775c78f9c6972fbd0bd9aee9d13446e7e))
 - **FIX**: package updates. ([0a934e2f](https://github.com/D-James-GH/cached_query/commit/0a934e2f5c99231e9d3644a40dae8d52bca5f814))
 - **FIX**: better generic type names. ([1e7fb516](https://github.com/D-James-GH/cached_query/commit/1e7fb5165cbc1fb864b7dc61a41d38ab35cd8fc6))

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-dev.2

 - **FEAT**: Added `buildWhen` to other query builders ([#15](https://github.com/D-James-GH/cached_query/issues/15)). ([a8f58359](https://github.com/D-James-GH/cached_query/commit/a8f583598b19a1fc11970f557dfdc3201f060b02))
 - **FEAT**: added `buildWhen` parameter in `QueryBuilder` for conditional rebuilding ([#14](https://github.com/D-James-GH/cached_query/issues/14)). ([4d2d3678](https://github.com/D-James-GH/cached_query/commit/4d2d36780c8050912793cc9bfe86534fb2f023da))

## 1.0.0-dev.1

 - chore: update packages

## 0.6.0+3

 - Update a dependency to the latest release.

## 0.6.0+2

 - Update a dependency to the latest release.

## 0.6.0+1

 - Update a dependency to the latest release.

## 0.6.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: combine updateInfiniteQuery and updateQuery in the global CachedQuery object. ([e8fd8602](https://github.com/D-James-GH/cached_query/commit/e8fd86029af9cebc9f06f0d20e432865a02db69e))

## 0.5.0+1

 - **DOCS**: update to query config flutter. ([2b729f49](https://github.com/D-James-GH/cached_query/commit/2b729f49a13864abb3d4f2bffadb0fdce2297fb0))

## 0.5.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: allow refetch config per query. QueryConfig can no longer be const.

## 0.4.1+4

 - Update a dependency to the latest release.

## 0.4.1+3

 - Update a dependency to the latest release.

## 0.4.1+2

 - Update a dependency to the latest release.

## 0.4.1+1

 - Update a dependency to the latest release.

## 0.4.1

 - **FEAT**: add creation and deletion observers.

## 0.4.0+1

 - **FIX**: export query observer.

## 0.4.0

> Note: This release has breaking changes.

 - **DOCS**: document query builder key.
 - **BREAKING** **FEAT**: add observer.

## 0.3.0+2

- Update Cached Query to the latest release.

## 0.3.0+1

 - **DOCS**: add base projects and infinite query with bloc.

## 0.3.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: reset infinite query data if first pages aren't equal, option to turn off.

## 0.2.0+1

 - Update a dependency to the latest release.

## 0.2.0

> Note: This release has breaking changes.

 - **FEAT**: update infinite query builder to have key as well.
 - **FEAT**: add ability to use query key only.
 - **BREAKING** **FEAT**: change query builds to either accept value or query key.

## 0.1.0+2

 - **DOCS**: Readmes updated to show documentation link.

## 0.1.0+1

 - Update a dependency to the latest release.

## 0.1.0

- **FIX!**: Infinite query not re-fetching in order.
- **FIX**: catch timeout.
- **DOCS**: Examples with the bloc pattern.
- **DOCS**: explain connection.

## 0.0.2+2

 - Update a dependency to the latest release.

## 0.0.2 
* fix: catch timeout

## 0.0.1-dev.1
* Initial release

