import 'package:cached_query_flutter/cached_query_flutter.dart';

class Observer extends QueryObserver {
  @override
  void onChange(
    QueryBase query,
    QueryState<dynamic> nextState,
  ) {
    // Do something when changing
    super.onChange(query, nextState);
  }
}
