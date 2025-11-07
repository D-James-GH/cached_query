/// The state of the connection.
enum ConnectionState {
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
abstract interface class ConnectionController {
  /// Called when the connection state changes.
  ///
  /// [previous] is the previous connection state.
  /// [current] is the current connection state.
  void onChange(ConnectionState previous, ConnectionState current);

  /// Whether the connection is active
  bool get hasConnection;

  /// Check the connection state.
  ///
  /// Returns true if the connection is active.
  Future<ConnectionState> checkConnection();
}
