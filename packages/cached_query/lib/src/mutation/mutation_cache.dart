import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/util/list_extension.dart';

/// Mutation cache is temporary in-memory storage for mutations while
/// they happen
class MutationCache {
  MutationCache._();

  final List<Mutation<dynamic, dynamic>> _mutationCache = [];

  /// Singleton instance of the mutation cache.
  static final instance = MutationCache._();

  /// Allow the creation of new instances
  factory MutationCache.asNewInstance() {
    return MutationCache._();
  }

  /// Retrieve a single mutation from the cache
  Mutation<T, A>? getMutation<T, A>(String key) {
    return _mutationCache.firstWhereOrNull((mut) => mut.key == key)
        as Mutation<T, A>?;
  }

  /// Remove a mutation from the cache
  void deleteMutation(String key) {
    if (contains(key)) {
      _mutationCache.removeWhere((mut) => mut.key == key);
    }
  }

  /// Add a mutation to the cache
  void addMutation<T, A>(Mutation<T, A> mutation) {
    assert(mutation.key != null, "Mutation must have a key if added to cache.");
    if (mutation.key != null) {
      _mutationCache.add(mutation);
    }
  }

  /// Check if a mutation is in the cache
  bool contains(String key) {
    return _mutationCache.any((mut) => mut.key == key);
  }
}
