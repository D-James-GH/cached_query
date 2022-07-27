---
title: Query
---

# Automatic Caching with Query

A query is used to cache single asynchronous requests in a unified and consistent way. The simplest form of a query is
shown below. No global configuration is needed, although possible.

```dart
final query = Query(key: "my_data", queryFn: () => api.getData());
```

A query must be given a unique key which can be any json serializable value. Each unique key will create a new query in
the cache.

A query will not invoke the queryFn until one of two things is used:

1. The `result` is requested via the future `Query.result`
2. A listener is added to the query stream.

## Query as a stream

## Query as a future

`Query.result` is a quick and easy way to request the result of a queryFn. It returns [QueryState](#query-state) once
the queryFn has completed. 


```dart
final query = Query(key: "my_data", queryFn: () => api.getData());

final queryState = await query.result;
```

There are a few downsides to using a query this way. The future always completes after the queryFn as completed. If the 
data is stale then nothing will show until fresh data is available, meaning you are not getting the benefits of 
background fetches. 

As the Queries use streams to detect how many listeners they have left getting the data via the future never adds a 
listener to the query. So, when the future is requested the [cache duration](/docs/guides/configuration) timer is started
immediately if there are no other listeners attached.




## Query State 
