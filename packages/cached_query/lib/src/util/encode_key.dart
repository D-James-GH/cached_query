import 'dart:convert';

String encodeKey(Object key) {
  if (key is String) return key;
  return jsonEncode(key);
}
