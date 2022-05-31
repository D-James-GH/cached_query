import 'package:cached_query/src/util/encode_key.dart';
import 'package:test/test.dart';

void main() {
  test("Should return string if input is string", () {
    const input = "input";
    final output = encodeKey(input);
    expect(input, output);
  });
  test("Should encode an object to a string", () {
    final output = encodeKey(["key", 1]);
    expect(output, isA<String>());
  });
}
