import 'dart:async';

/// An interface for any storage adapter.
///
/// Used by the [CachedStorage] plugin to save the current cache.
abstract class StorageInterface {
  /// Get stored data from the storage instance.
  FutureOr<StoredQuery?> get(String key);

  /// Delete the cache at a given key.
  void delete(String key);

  /// Update or add data with a given key. Add a duration to prevent old data being shown.
  void put(StoredQuery query);

  /// Delete all stored data.
  void deleteAll();

  /// Close and clean up the storage instance.
  void close();
}

/// {@template StoredQuery}
/// The data stored in the database
/// {@endtemplate}
class StoredQuery {
  /// The query key
  final String key;

  /// The query data
  final dynamic data;

  /// The query expiry
  final DateTime createdAt;

  /// The length of time before the query expires.
  final Duration? storageDuration;

  /// The query expiry time.
  final DateTime? expiry;

  /// {@macro StoredQuery}
  StoredQuery({
    required this.key,
    required this.data,
    required this.createdAt,
    this.storageDuration,
  }) : expiry = storageDuration == null ? null : createdAt.add(storageDuration);

  /// Whether the query is expired.
  bool get isExpired => expiry != null && expiry!.isBefore(DateTime.now());

  /// Whether the query is not expired.
  bool get isNotExpired => !isExpired;

  /// Create a new [StoredQuery] from from the current instance.
  StoredQuery copyWith({
    String? key,
    dynamic data,
    DateTime? createdAt,
    Duration? storageDuration,
  }) {
    return StoredQuery(
      key: key ?? this.key,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      storageDuration: storageDuration ?? this.storageDuration,
    );
  }
}
