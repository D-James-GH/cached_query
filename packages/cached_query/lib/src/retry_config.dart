import 'dart:async';

/// {@template RetryConfig}
/// Configuration for retrying failed query fetches.
///
/// Add to [QueryConfig.retryConfig] or [GlobalQueryConfig.retryConfig].
/// {@endtemplate}
class RetryConfig {
  /// Maximum number of retry attempts after the initial fetch fails.
  final int maxRetries;

  /// Delay before each retry attempt. [attempt] is 1-indexed.
  ///
  /// If null, exponential backoff is used:
  /// `Duration(milliseconds: 200 << (attempt - 1))`
  /// (200ms, 400ms, 800ms, …)
  final Duration Function(int attempt)? delay;

  /// Called before each retry to decide whether to retry.
  ///
  /// [attempt] is 1-indexed. If null, all errors are retried.
  final FutureOr<bool> Function(Object error, int attempt)? whenError;

  /// {@macro RetryConfig}
  const RetryConfig({
    required this.maxRetries,
    this.delay,
    this.whenError,
  });
}
