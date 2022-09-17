import 'package:collection/collection.dart';

/// Checks whether two pages in a Infinite Query are equal
bool pageEquality(dynamic page1, dynamic page2) {
  if (page1 is Iterable && page2 is Iterable) {
    return const IterableEquality<dynamic>().equals(page1, page2);
  }
  return page1 == page2;
}
