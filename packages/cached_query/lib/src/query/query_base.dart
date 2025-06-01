part of "_query.dart";

sealed class Cacheable<State> {
  String get key;
  Object get unencodedKey;
  State get state;
  Stream<State> get stream;
  bool get stale;
  bool get hasListener;

  Future<State> fetch();
  Future<State> refetch();
  void deleteQuery({bool deleteStorage});
  Future<void> invalidate({
    bool refetchActive,
    bool refetchInactive,
  });
}
