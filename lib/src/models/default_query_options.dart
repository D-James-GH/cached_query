class DefaultQueryOptions {
  final Duration cacheTime;
  final Duration staleTime;

  const DefaultQueryOptions({
    this.cacheTime = const Duration(minutes: 5),
    this.staleTime = const Duration(seconds: 30),
  });
}
