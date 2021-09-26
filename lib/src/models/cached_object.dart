class CachedObject<T> {
  T data;
  DateTime timeCreated;

  CachedObject({
    required this.data,
    required this.timeCreated,
  });
}
