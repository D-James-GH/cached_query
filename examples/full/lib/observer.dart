import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/foundation.dart';

class Observer extends QueryObserver {
  @override
  void onChange(
    QueryBase<dynamic, dynamic> query,
    QueryState<dynamic> nextState,
  ) {
    debugPrint(nextState.status.toString());
    super.onChange(query, nextState);
  }
}
