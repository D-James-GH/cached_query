import 'dart:convert';

/// Stringifies the [key].
///
/// A [key] can be any value that can be stringifies. If the key is a string
/// do nothing.
String encodeKey(Object key) {
  if (key is String) return key;
  return jsonEncode(key);
}
