import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extension/src/cached_query_extension.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [ErrorLoggerObserver()],
      child: const DevToolsExtension(
        child: CachedQueryExtension(),
      ),
    ),
  );
}

class ErrorLoggerObserver extends ProviderObserver {
  final log = Logger(printer: SimplePrinter());
  ErrorLoggerObserver();

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    _maybeLogError(provider, value);
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _maybeLogError(provider, newValue);
  }

  void _maybeLogError(ProviderBase provider, Object? value) {
    if (value is AsyncError) {
      if (value.error is SentinelException) return;
      log.e(
        'Provider $provider failed',
        error: value.error,
        stackTrace: value.stackTrace,
      );
    }
  }
}
