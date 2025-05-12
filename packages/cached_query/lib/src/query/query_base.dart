part of "_query.dart";

sealed class QueryBase {
  final String key;
  final Object unencodedKey;
  bool get hasListener;
  QueryBase({
    required this.key,
    required this.unencodedKey,
  });

  // Future<State> refetch();
  // void update(UpdateFunc<dynamic> updateFn);
}

abstract interface class Cacheable<Data, State> {
  String get key;
  Object get unencodedKey;
  State get state;
  Stream<State> get stream;
  bool get stale;
  bool get hasListener;

  Future<State> fetch();
  Future<State> refetch();
  void update(UpdateFunc<Data> updateFn);
  void deleteQuery({bool deleteStorage});
  Future<void> invalidate({
    bool refetchActive,
    bool refetchInactive,
  });
}
