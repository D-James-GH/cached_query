---
title: Query
---

# Automatic Caching with Query

A query is used to cache single asynchronous requests in a unified and consistent way. The simplest form of a query is
shown below. No global configuration is needed, although possible.

```dart
final query = Query(
  key: "my_data", 
  initialData: "Pre-populated data",
  queryFn: () => api.getData(),
);
```

Each Query must have a queryFn. This is an asynchronous function that can return any custom or built in type. The return 
value of the queryFn will be cached. 

A query must be given a unique key which can be any json serializable value. Each unique key will create a new query in
the cache. Initial data can be passed to the query. On the first request this initial data will be emitted as part of the state 
rather than null. Any global query configuration can be overridden when instantiating a new query. See [configuration](/docs/guides/configuration)
for more details.

Each query can be updated using `Query.update`. This change will be emitted to any listening query. For more information
on updating a query see [optimistic updates](/docs/guides/optimistic-updates)

### Query State
`QueryState` is the object containing the current state of the query. It holds the **data** returned from the queryFn
along with the current status of the query (loading, success, error, initial), the time of the last fetch and any errors
throw in the fetch.
```dart
final state = query.state;
final isLoading = state.status == QueryStatus.loading;
final data = state.data;
```

A query can only hold one future at a time. This is so that the result can be requested from many places at once but only
one call to the queryFn will be made. A query will not invoke the queryFn until one of two things is used:

1. The `result` is requested via the future `Query.result`
2. A listener is added to the query stream.

## Query Stream

Each query manages its own stream controller. Streams enable a query to display currently existing data while fetching 
new data in the background. When the new data is ready it will be emitted. A query stream will also emit any time the 
state of the query is changed, this is useful for [mutations](/docs/guides/mutations) and 
[optimistic updates](/docs/guides/optimistic-updates).


```dart
final query = Query(key: "my_data", queryFn: () => api.getData());

query.stream((state) {
  if(state.status == QueryStatus.loading){
    // show loading spinner
  }
  if(state.data != null){
    // update ui to show the data.
  }
});
```

## Query Result

`Query.result` is a quick and easy way to request the result of a queryFn. It returns [QueryState](#query-state) once
the queryFn has completed. For the full benefits of Cached Query use the stream api.


```dart
final query = Query(key: "my_data", queryFn: () => api.getData());

final queryState = await query.result;
```

There are a few downsides to using a query this way. The future always completes after the queryFn has completed. If the 
data is stale then nothing will show until fresh data is available, meaning you are not getting the benefits of 
background fetches. 

As the Queries use streams to detect how many listeners they have left, using `Query.result` never adds a 
listener to the query. So, when the future is requested the [cache duration](/docs/guides/configuration) timer is started
immediately if there are no other listeners attached.

## Error Handling

If a query, infinite query or a mutation throws an error or exception it will be caught and the current state will be
updated with the error. 

## Side Effects

There are two side effects that can be passed to a query. 
- `onSuccess` - This is called after the query function succeeds but before the query state is updated.
- `onError` - This is called if the query function fails but before the query state is updated.
```dart
final query = Query<String>(
  key: "onSuccess",
  onSuccess: (dynamic r) { 
    // do something with the response
  },
  onError: (dynamic e){
    // do something with the error
  },
  queryFn: () async {
    //...queryFn
  },
);
```
