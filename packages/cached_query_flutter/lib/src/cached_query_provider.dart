import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/widgets.dart';

import 'query_builder.dart';

/// {@template cachedQueryProvider}
/// Enables [BuildContext.watchQuery] and [BuildContext.watchInfiniteQuery]
/// for all widgets in the subtree.
///
/// Place near the root of your widget tree, passing the [CachedQuery] instance
/// used for key-based lookups.
///
/// ```dart
/// // Uses CachedQuery.instance by default.
/// CachedQueryProvider(
///   child: MaterialApp(...),
/// )
///
/// // Or pass an explicit instance.
/// CachedQueryProvider(
///   cache: myCache,
///   child: MaterialApp(...),
/// )
/// ```
/// {@endtemplate}
class CachedQueryProvider extends StatefulWidget {
  /// The [CachedQuery] instance used for key-based query lookups.
  ///
  /// Defaults to [CachedQuery.instance] when omitted.
  final CachedQuery? cache;

  /// The widget below this widget in the tree.
  final Widget child;

  /// {@macro cachedQueryProvider}
  const CachedQueryProvider({
    super.key,
    this.cache,
    required this.child,
  });

  @override
  State<CachedQueryProvider> createState() => _CachedQueryProviderState();
}

typedef _BuildWhenCallback = FutureOr<bool> Function(
  Object? oldState,
  Object? newState,
);

class _QueryEntry {
  StreamSubscription<dynamic> subscription;
  final Map<Element, _ElementWatcher> watchers = {};

  _QueryEntry({required this.subscription});
}

class _ElementWatcher {
  Object? lastState;
  final _BuildWhenCallback? buildWhen;

  _ElementWatcher({required this.lastState, this.buildWhen});
}

class _CachedQueryProviderState extends State<CachedQueryProvider> {
  final Map<String, _QueryEntry> _subscriptions = {};

  @override
  Widget build(BuildContext context) {
    return _CachedQueryScope(
      providerState: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    for (final entry in _subscriptions.values) {
      entry.subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  void _registerWatcher({
    required Element element,
    required Cacheable<dynamic> query,
    required bool enabled,
    _BuildWhenCallback? buildWhen,
  }) {
    final key = query.key;

    if (!enabled) {
      _decrementWatcher(element, key);
      return;
    }

    if (!_subscriptions.containsKey(key)) {
      _subscriptions[key] = _QueryEntry(
        subscription: query.stream.listen((newState) {
          _notifyWatchers(key, newState);
        }),
      );
    }

    _subscriptions[key]!.watchers[element] = _ElementWatcher(
      lastState: query.state,
      buildWhen: buildWhen,
    );
  }

  void _decrementWatcher(Element element, String key) {
    final entry = _subscriptions[key];
    if (entry == null) return;
    entry.watchers.remove(element);
    if (entry.watchers.isEmpty) {
      entry.subscription.cancel();
      _subscriptions.remove(key);
    }
  }

  Future<void> _notifyWatchers(String key, dynamic newState) async {
    final entry = _subscriptions[key];
    if (entry == null) return;
    for (final MapEntry(:key, :value) in entry.watchers.entries.toList()) {
      final element = key;
      final watcher = value;
      bool shouldRebuild = true;
      if (watcher.buildWhen != null) {
        shouldRebuild = await Future.value(
          watcher.buildWhen!(watcher.lastState, newState),
        );
      }
      if (shouldRebuild) {
        watcher.lastState = newState;
        element.markNeedsBuild();
      }
    }
  }
}

class _CachedQueryScope extends InheritedModel<String> {
  final _CachedQueryProviderState providerState;

  const _CachedQueryScope({
    required this.providerState,
    required super.child,
  });

  @override
  bool updateShouldNotify(_CachedQueryScope oldWidget) => false;

  @override
  bool updateShouldNotifyDependent(
    covariant _CachedQueryScope oldWidget,
    Set<String> dependencies,
  ) =>
      false;

  @override
  _CachedQueryScopeElement createElement() => _CachedQueryScopeElement(this);
}

class _CachedQueryScopeElement extends InheritedModelElement<String> {
  _CachedQueryScopeElement(super.widget);

  @override
  void removeDependent(Element dependent) {
    final deps = getDependencies(dependent);
    if (deps is Set<String>) {
      final scope = widget as _CachedQueryScope;
      for (final key in deps) {
        scope.providerState._decrementWatcher(dependent, key);
      }
    }
    super.removeDependent(dependent);
  }
}

/// Extension providing [watchQuery] and [watchInfiniteQuery] on [BuildContext].
///
/// Requires a [CachedQueryProvider] ancestor in the widget tree.
extension QueryWatchContext on BuildContext {
  /// Watch a [Query] and rebuild when its state changes.
  ///
  /// Provide either [query] or [key] — one is required.
  ///
  /// When [key] is provided and no matching query exists in the cache, an empty
  /// query is created automatically (same behaviour as [CachedQuery.setQueryData]
  /// on a missing key).
  ///
  /// Set [enabled] to `false` to return a state snapshot without subscribing.
  /// The subscription is (re-)created when [enabled] returns to `true` on the
  /// next build.
  QueryStatus<T> watchQuery<T>({
    Object? key,
    Query<T>? query,
    QueryBuilderCondition<QueryStatus<T>>? buildWhen,
    bool enabled = true,
  }) {
    assert(
      key != null || query != null,
      'Either key or query must be provided to watchQuery.',
    );

    final scopeElement =
        getElementForInheritedWidgetOfExactType<_CachedQueryScope>();
    assert(
      scopeElement != null,
      'No CachedQueryProvider found in the widget tree. '
      'Wrap your app with CachedQueryProvider.',
    );
    final providerState =
        (scopeElement!.widget as _CachedQueryScope).providerState;

    final Query<T> resolved;
    if (query != null) {
      resolved = query;
    } else {
      final cache = providerState.widget.cache ?? CachedQuery.instance;
      final found = cache.getQuery<Query<T>>(key!);
      resolved = found ?? createEmptyQuery<T>(key: key, cache: cache);
    }

    InheritedModel.inheritFrom<_CachedQueryScope>(this, aspect: resolved.key);

    providerState._registerWatcher(
      element: this as Element,
      query: resolved,
      enabled: enabled,
      buildWhen: buildWhen != null
          ? (old, next) => buildWhen(
                old as QueryStatus<T>,
                next as QueryStatus<T>,
              )
          : null,
    );

    return resolved.state;
  }

  /// Watch an [InfiniteQuery] and rebuild when its state changes.
  ///
  /// Provide either [query] or [key] — one is required. When using [key], the
  /// [InfiniteQuery] must already exist in the cache.
  ///
  /// Set [enabled] to `false` to return a state snapshot without subscribing.
  InfiniteQueryStatus<T, Arg> watchInfiniteQuery<T, Arg>({
    Object? key,
    InfiniteQuery<T, Arg>? query,
    QueryBuilderCondition<InfiniteQueryStatus<T, Arg>>? buildWhen,
    bool enabled = true,
  }) {
    assert(
      key != null || query != null,
      'Either key or query must be provided to watchInfiniteQuery.',
    );

    final scopeElement =
        getElementForInheritedWidgetOfExactType<_CachedQueryScope>();
    assert(
      scopeElement != null,
      'No CachedQueryProvider found in the widget tree. '
      'Wrap your app with CachedQueryProvider.',
    );
    final providerState =
        (scopeElement!.widget as _CachedQueryScope).providerState;

    final InfiniteQuery<T, Arg> resolved;
    if (query != null) {
      resolved = query;
    } else {
      final cache = providerState.widget.cache ?? CachedQuery.instance;
      final found = cache.getQuery<InfiniteQuery<T, Arg>>(key!);
      assert(
        found != null,
        'No InfiniteQuery found with key $key. '
        'Create the InfiniteQuery before watching it by key.',
      );
      resolved = found!;
    }

    InheritedModel.inheritFrom<_CachedQueryScope>(this, aspect: resolved.key);

    providerState._registerWatcher(
      element: this as Element,
      query: resolved,
      enabled: enabled,
      buildWhen: buildWhen != null
          ? (old, next) => buildWhen(
                old as InfiniteQueryStatus<T, Arg>,
                next as InfiniteQueryStatus<T, Arg>,
              )
          : null,
    );

    return resolved.state;
  }
}
