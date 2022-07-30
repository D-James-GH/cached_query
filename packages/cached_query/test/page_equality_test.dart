import 'package:cached_query/src/util/page_equality.dart';
import 'package:test/test.dart';

import 'repos/test_models.dart';

void main() {
  group("Page equality", () {
    test("Page when lists and have same items should be equal", () {
      final res = pageEquality([1, 2, 3], [1, 2, 3]);
      expect(res, true);
    });

    test("Lists with objects", () {
      final res = pageEquality([
        TitleWithEquality("title1"),
        TitleWithEquality("title2"),
        3,
      ], [
        TitleWithEquality("title1"),
        TitleWithEquality("title2"),
        3,
      ]);
      expect(res, true);
    });
    test("Objects should use == operator", () {
      pageEquality(TitleWithEquality("title"), TitleWithEquality("title"));
    });
  });
}
