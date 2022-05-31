/// Library helper extensions
extension ListExt on Iterable<dynamic>? {
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
