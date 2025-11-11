import 'dart:async';

import 'package:cached_query/cached_query.dart';

/// The state of the connection.
enum ConnectionStatus {
  /// The connection is active.
  connected,

  /// The connection is inactive.
  disconnected,

  /// The connection state is unknown.
  unknown;

  /// Whether the connection is active.
  bool get isConnected => this == connected;
}

/// {@template ConnectionController}
/// Controller interface for monitoring the connection state.
/// {@endtemplate}
class ConnectionController {
  /// {@macro ConnectionController}
  ConnectionController({required this.cache, required this.connectionStream}) {
    _connectionSubscription = connectionStream.listen((state) {
      final previousState = _currentState;
      _currentState = state;
      _handleChange(previousState, state);
    });
  }
  late final StreamSubscription<ConnectionStatus> _connectionSubscription;

  /// The cached query instance.
  final CachedQuery cache;

  /// The connection state stream.
  final Stream<ConnectionStatus> connectionStream;
  ConnectionStatus _currentState = ConnectionStatus.unknown;

  void _handleChange(ConnectionStatus previous, ConnectionStatus current) {
    if (previous != current && current.isConnected) {
      final queries = cache.whereQuery((query) {
        if (!query.hasListener) {
          return false;
        }
        final config = switch (query) {
          Query() => query.config,
          InfiniteQuery() => query.config,
        };
        return config.refetchOnConnection;
      }).toList();

      if (queries.isNotEmpty) {
        for (final q in queries) {
          q.fetch();
        }
      }
    }
  }

  /// Whether the connection is active
  bool get hasConnection => _currentState.isConnected;

  /// Dispose the controller.
  Future<void> dispose() async {
    await _connectionSubscription.cancel();
  }
}
