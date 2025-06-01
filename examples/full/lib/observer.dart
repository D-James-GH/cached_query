import 'package:cached_query_flutter/cached_query_flutter.dart';

class Observer extends QueryObserver {
  @override
  void onChange(
    Cacheable<dynamic> query,
    QueryState<dynamic> nextState,
  ) {
    // Do something when changing
    super.onChange(query, nextState);
  }
}
