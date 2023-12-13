extension IterableExt on Iterable {
  Iterable<(int, R)> enumerate<R>() sync* {
    var index = 0;
    for (var element in this) {
      yield (index++, element);
    }
  }
}
