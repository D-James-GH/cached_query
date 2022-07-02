import 'dart:io';

/// Looks up an address to check connection.
class ConnectivityService {
  /// Looks up "example.com" to test for a connection.
  ///
  /// Returns true if a host could be found.
  Future<bool> lookup() async {
    final res = await InternetAddress.lookup('example.com')
        .timeout(const Duration(seconds: 5));
    return res.isNotEmpty && res.first.rawAddress.isNotEmpty;
  }
}
