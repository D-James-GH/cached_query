import 'dart:async';
import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///
class LifecycleStreamController {
  ///
  LifecycleStreamController(CachedQuery cache) {
    _observer = _LifecycleObserver(
      cache,
      _controller.add,
    );
    WidgetsBinding.instance.addObserver(_observer);
  }
  final _controller = StreamController<AppState>.broadcast();
  late final _LifecycleObserver _observer;

  ///
  Stream<AppState> get stream => _controller.stream;

  /// Dispose the controller
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(_observer);
    await _controller.close();
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  final CachedQuery cache;
  final void Function(AppState) onChange;

  _LifecycleObserver(
    this.cache,
    this.onChange,
  );

  DateTime? _lastPaused;

  bool shouldNotify() {
    if (_lastPaused == null) {
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        return false;
      }
      // Note: Other platforms might never enter full background mode so we
      // return true to be safe (only if we have no last paused time).
      return true;
    }

    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final shouldNotify = this.shouldNotify();
      _lastPaused = null;

      if (shouldNotify) {
        onChange(AppState.foreground);
      }
      return;
    }

    if (state == AppLifecycleState.paused) {
      _lastPaused = DateTime.now();
      onChange(AppState.background);
    }
  }
}
