part of "_query.dart";

sealed class QueryBase {
  String get key;
  Object get unencodedKey;
  // State get state;
  // bool get stale;
  //
  // Future<State> refetch();
  //
  // void update(UpdateFunc<dynamic> updateFn);
  //
  // Future<void> invalidate({
  //   bool refetchActive,
  //   bool refetchInactive,
  // });
}
