import 'package:cached_query/cached_query.dart';

/// Mutation cache is temporary in-memory storage for mutations while
/// they happen
class MutationCache {
  /// Singleton instance of the mutation cache.
  static final instance = MutationCache._();
  final Map<String, Mutation<dynamic, dynamic>> _mutationCache = {};
  MutationCache._();

  /// Retrieve a single mutation from the cache
  Mutation<T, A>? getMutation<T, A>(String key) {
    if (_mutationCache.containsKey(key)) {
      return _mutationCache[key] as Mutation<T, A>;
    }
    return null;
  }

  /// Remove a mutation from the cache
  void deleteMutation(String key) {
    if (_mutationCache.containsKey(key)) {
      _mutationCache.remove(key);
    }
  }

  /// Add a mutation to the cache
  void addMutation<T, A>(Mutation<T, A> mutation) {
    if (mutation.key != null) {
      _mutationCache[mutation.key!] = mutation;
    }
  }
}
