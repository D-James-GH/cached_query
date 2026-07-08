import 'dart:async';

import 'package:shelf/shelf.dart';

/// Applies an optional [delay] query parameter in milliseconds before handling.
Middleware delayMiddleware = (Handler innerHandler) {
  return (Request request) async {
    final delayMs =
        int.tryParse(request.url.queryParameters['delay'] ?? '') ?? 500;
    if (delayMs > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }
    return innerHandler(request);
  };
};
