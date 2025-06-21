/// Library helper extensions
extension NullableIterableExt<T> on Iterable<T>? {
  /// Weather this [Iterable] is either null or empty.
  bool get isNullOrEmpty {
    if (this == null || this!.isEmpty) {
      return true;
    }
    return false;
  }

  /// Weather this [Iterable] is neither null or empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

/// Iterable helper extensions
extension IterableExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
