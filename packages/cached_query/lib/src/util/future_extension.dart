import 'dart:async';

/// Extension on Future.
extension FutureExtension<T> on Future<T> {
  /// Checks weather this [Future] has returned a value, using a completer.
  bool isCompleted() {
    final completer = Completer<T>();
    then(completer.complete).catchError(completer.completeError);
    return completer.isCompleted;
  }
}