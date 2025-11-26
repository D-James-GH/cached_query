import 'dart:async';

import 'package:cached_query/cached_query.dart';

/// {@template ResumeController}
/// A controller to handle application resume events.
/// {@endtemplate}
class ResumeController {
  /// {@macro ResumeController}
  ResumeController({required this.cache, required this.lifecycleStream}) {
    _lifecycleSubscription = lifecycleStream.listen(_handleChange);
  }

  /// The cached query instance.
  final CachedQuery cache;

  /// The lifecycle stream to listen to.
  final Stream<AppState> lifecycleStream;
  AppState _currentState = AppState.foreground;
  DateTime _lastPaused = DateTime.now();
  late final StreamSubscription<AppState> _lifecycleSubscription;

  void _handleChange(AppState newState) {
    if (_currentState == newState) {
      return;
    }
    final previousState = _currentState;
    _currentState = newState;
    if (newState == AppState.background) {
      _lastPaused = DateTime.now();
    } else if (newState == AppState.foreground) {
      if (shouldRefetch(previousState, newState)) {
        onResume();
      }
    }
  }

  /// Determine if queries should be refetched based on the time spent
  bool shouldRefetch(AppState previous, AppState current) {
    final diff = DateTime.now().difference(_lastPaused);
    return diff > cache.defaultConfig.refetchOnResumeMinBackgroundDuration;
  }

  /// Called when the application resumes from a paused state.
  void onResume() {
    final queries = cache.whereQuery((query) {
      if (!query.hasListener) {
        return false;
      }
      final config = switch (query) {
        Query() => query.config,
        InfiniteQuery() => query.config,
      };
      return config.refetchOnResume;
    }).toList();
    if (queries.isNotEmpty) {
      for (final q in queries) {
        q.fetch();
      }
    }
  }

  /// Dispose the controller.
  Future<void> dispose() async {
    await _lifecycleSubscription.cancel();
  }
}

/// The lifecycle state of the application.
enum AppState {
  /// The application has moved to the foreground.
  foreground,

  /// The application has moved to the background.
  background,
}
